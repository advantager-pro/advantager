module Advantager::EarnedSchedule
  extend ActiveSupport::Concern
  included do
    def es_start_date
      self.project.start_date
    end

    def last_period
      ( (es_planned_completion_date - es_start_date) / period_duration ).to_i
    end

    def periods
      last_period.times.map{ |e| e+1 }
    end

    def period_duration
      self.project.evm_frequency
    end

    def current_period
      ( (Date.today - es_start_date) / period_duration ).to_i
    end

    def es_to_date(period)
      es_start_date + (period * period_duration).days
    end

    # def to_period(date)
    #   date / period_duration
    # end

    def BCWP(period)
      self.project.earned_value(es_to_date(period))
    end

    def BCWS(period)
      self.project.planned_value(es_to_date(period))
    end

    def find_period_x(period)
      period ||= current_period
      periods.reverse.find{ |x| BCWP(period) >= BCWS(x) }
    end

    # Point in period when current progress was planned to occur
    def earned_schedule(period=nil)
      # Earned Schedule =
      # Whole months completed were Σ BCWP ≥ Σ BCWS + fractional month
      # completed
      # = Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
      # (X = whole month earned; Y = month following X; T = Actual TIme)
      # x = whole_month_earned
      # y = next_month
      # t = es_actual_time

      # Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
      # x = whole month earned; y = month following x; t = Actual Time (Time Now)
      # byebug
      period ||= current_period
      t = es_actual_time(period)
      x = find_period_x(t)
      y =  x + 1
      bCWSx = BCWS(x)
      pv_t = BCWP(t)
      bCWSy = BCWS(y)
      return  x + ( ( pv_t - bCWSx).to_f / (bCWSy - bCWSx).to_f  )
    end

    def es_schedule_variance(period=nil)
      earned_schedule(period) - es_actual_time(period)
    end

    def es_schedule_performance_index(period=nil)
      earned_schedule(period) / es_actual_time(period)
    end

    def es_actual_time(period)
      # AT is “Actual Time” – the duration from start to the duration
      #  from start to period now
      period || current_period
      #  for example: 10 months
    end


    #  PD = Planned Duration (planned project duration)
    def es_planned_duration(period)
      # why would you use period here?

      # Planned project duration
      # Total PV or amount of periods?
      # es_planned_completion_date # nd_date # this ?
      # to_period(self.project.due_date) # or this?
      last_period
    end

    # Remaining work
    def es_es_planned_duration_work_remaining(period)
      # PDWR= PD-EScum
      es_planned_duration(period) - earned_schedule(period)
    end

    def es_estimate_at_complete1(period) # basic
      # EAC(t) = PD/SPI(t)
      es_planned_duration / es_schedule_performance_index(period)
    end

    def es_estimate_at_complete2(period) # complex (?)
      # EAC(t)(2) = AT+(PD-ES)/SPI(t)
      es_actual_time + (es_planned_duration - earned_schedule) / es_schedule_performance_index(period)
    end

    def es_to_complete_performance_index1 #
      # TSPI = (PD-ES)/(PD-AT)
      (es_planned_duration - earned_schedule) / (es_planned_duration - es_actual_time)
    end

    def es_to_complete_performance_index2
      # TSPI= (PD-ES)/(ED-AT)
      (es_planned_duration - earned_schedule) / (es_estimated_duration - es_actual_time)
    end

    #  ED = Estimated Duration (estimated project duration)
    def es_estimated_duration(period=nil)
      period ||= current_period
      # period ?
      es_planned_duration(period) / es_schedule_performance_index(period)
      #  es_estimated_duration seems to be = es_independent_time_estimate_at_compete
      # es_estimated_duration example value: 30 months
    end

    def es_independent_time_estimate_at_compete(period=nil)
      es_planned_duration(period) / es_schedule_performance_index(period)
    end

    # PCD = Planned Completion Date (Planned project end date)
    def es_planned_completion_date
      self.project.due_date
    end

    # ECD = Estimated Completion Date (Estimated project end date)
    def estimated_completion_date(period=nil)
      es_start_date + es_independent_time_estimate_at_compete(period) #es_estimated_duration
    end
  end
  module ClassMethods
  end
end
