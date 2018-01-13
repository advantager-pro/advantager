module Advantager::EarnedSchedule
  extend ActiveSupport::Concern
  included do
    def es_start_date
      self.project.start_date
    end

    def last_period
      # This block is executed when we use the Planned Date
      #
      # For PD we want the biggest period
      # If for example we want to get the PD period.
      # We would want the period at the end,
      # instead of the nearest period
      # start = 0, period duration = 7, date = 3
      # it will result as the end of that period,
      # which is the next period: 1
      es_to_period(planned_completion_date).ceil
    end

    def last_periods_until(until_period)
      build_period_list(until_period).reverse
    end

    def available_periods
      build_period_list(last_period)
    end

    def current_period
      # We have to round the result so if the date is in the
      # middle of a period. For example:
      # start = 0, period duration = 7, date = 3
      # The result will be the nearest period to that date
      # Which, in this example, is the first period: 0
      es_to_period(self.day).floor
    end

    def period_duration
      self.project.evm_frequency
    end

    def es_to_date(period)
      es_start_date + (period * period_duration).days
    end

    def es_to_period(date)
      # Use to_f in order to delate the way the result
      # will be rounded (ceil, floor, etc) to the methods
      # that use #es_to_period
      ( (date - es_start_date) / period_duration ).to_f
    end

    def BCWP(period) # EV
      error_message = "Do not get EV from periods > current.. you don't want EV from the future"
      raise error_message if period.present? && period > current_period
      self.project.earned_value(es_to_date(period))
    end

    def BCWS(period) # PV
      self.project.planned_value(es_to_date(period))
    end

    def find_period_x(period)
      # x is the most recent period where
      # the current EV >= the period x PV
      last_periods_until(period).find{ |x| BCWP(period) >= BCWS(x) }
    end

    def calculate_earned_schedule
      # The Earned schedule is the point in period
      # when current progress (EV) was planned to occur

      t = current_period # t = Actual Time (Time Now)

      # In the first period we have no previous period
      # so the earned schedule is 0
      return 0 if current_period == first_period

      # x is the most recent period where
      # the current EV >= the period x PV
      x = find_period_x(t) # x = whole period earned

      # x is nil if there is no previous period where
      # the current EV >= the PV of any previous period
      # Which means we are very behind the schedule
      # so behind that we couldn't accomplish the PV for the first period yet
      # so we are not earning schedule
      # then let's return 0
      return 0 if x.nil?

      y =  x + 1 # y = period following x
      bCWSx = BCWS(x) # PV(x)
      ev_t = BCWP(t) # EV(t)
      bCWSy = BCWS(y) # PV(y)

      # Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
      return  x + ( ( ev_t - bCWSx).to_f / (bCWSy - bCWSx).to_f )
    end


    def to_complete_schedule_performance_index_pd
      # TSPI = (PD-ES)/(PD-AT)
      (es_planned_duration - earned_schedule) / (es_planned_duration - current_period)
    end
  
    def to_complete_schedule_performance_index_ieac
      # TSPI= (PD-ES)/(ED-AT)
      (es_planned_duration - earned_schedule) / (es_estimated_duration - current_period)
    end


    def es_schedule_variance
      earned_schedule - current_period
    end

    def es_schedule_performance_index
      earned_schedule / current_period
    end

    #  PD = Planned Duration (planned project duration)
    def es_planned_duration
      # The planned duration is the last period
      # which is calculated based on the biggest
      # planned due date of the project's issues

      pd = last_period

      # If we are on the last period already
      # and we still didn't finish the project
      # It means that the PD might go until
      # the end of the current period which is
      # the next period.
      # This way we also avoid infinity numbers on
      # methods such as:
      #   #to_complete_schedule_performance_index_pd
      # where:
      #   PD - current period
      # is used as dividend
      if last_period == current_period
        pd += 1
      end

      pd
      # Notice PD is a period given that all
      # the earned schedule formulas are in terms
      # of periods
    end

    # Remaining work
    def es_es_planned_duration_work_remaining
      # PDWR= PD-EScum
      es_planned_duration - earned_schedule
    end

    def es_estimate_at_complete1 # basic
      # EAC(t) = PD/SPI(t)
      es_planned_duration / es_schedule_performance_index
    end

    def es_estimate_at_complete2 # complex (?)
      # EAC(t)(2) = AT+(PD-ES)/SPI(t)
      current_period + (es_planned_duration - earned_schedule) / es_schedule_performance_index
    end

    # ED = Estimated Duration (estimated project duration)
    def es_estimated_duration
      es_planned_duration / es_schedule_performance_index
    end

    def es_independent_time_estimate_at_compete
      es_planned_duration / es_schedule_performance_index
    end

    # PCD = Planned Completion Date (Planned project end date)
    def planned_completion_date
      self.project.due_date
    end

    # ECD = Estimated Completion Date (Estimated project end date)
    def estimated_completion_date
      es_to_date(es_independent_time_estimate_at_compete)
    end

    def set_earned_schedule
      self.earned_schedule = calculate_earned_schedule
    end

    before_save do
      set_earned_schedule
    end

    private

      def first_period
        # Periods starts with 0 given that
        # when a date is converted to period
        # if it's in the first period
        # it will be equal 0
        # For more info check: #es_to_period
        0
      end

      def build_period_list(until_period)
        # We have to + 1 until_period in order to
        # include the desired period in the list
        # For example: we want a list of periods
        #   from the first period: 0
        #   until the period 2, which should be
        #   included on the list.
        #   2.times.to_a will return: [0,1]
        #   but we want [0,1,2]
        (until_period + 1).times.to_a
      end
  end

  module ClassMethods
  end
end
