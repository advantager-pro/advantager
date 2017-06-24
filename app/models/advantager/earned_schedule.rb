module Advantager::EarnedSchedule
  extend ActiveSupport::Concern
  included do
    def es_start_date
      self.project.start_date
    end

    def last_period
      ( (planned_completion_date - es_start_date) / period_duration ).to_i
    end

    def periods(until_period = nil)
      (until_period || last_period).times.map{ |e| e }
    end

    def period_duration
      self.project.evm_frequency
    end

    def current_period
      ( (self.day - es_start_date) / period_duration ).to_i
    end

    def es_to_date(period)
      es_start_date + (period * period_duration).days
    end

    def BCWP(period) # EV
      # Do not get EV from periods > current.. you don't want EV from the future
      return 0 if period.present? && period > current_period 
      self.project.earned_value(es_to_date(period))
    end

    def BCWS(period) # PV
      self.project.planned_value(es_to_date(period))
    end

    def find_period_x(period)
      period ||= current_period
      periods(period + 1).reverse.find{ |x| BCWP(period) > BCWS(x) }
    end

    # Point in period when current progress was planned to occur
    def calculate_earned_schedule
      # Earned Schedule =
      # Whole months completed were Σ BCWP ≥ Σ BCWS + fractional month
      # completed
      # = Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
      # (X = whole month earned; Y = month following X; T = Actual TIme)

      # x = whole month earned; y = month following x; t = Actual Time (Time Now)

      return 0 if current_period == 0
      # t = Actual Time
      t = current_period
      # Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
      # x = whole_month_earned
      x = find_period_x(t) #|| t
      if x.nil? # current period 1? # 2? 
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{t}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        # byebug
        return 0
      end
      # y = next_month
      y =  x + 1
      bCWSx = BCWS(x) # PV(x)
      ev_t = BCWP(t) # EV(t)
      bCWSy = BCWS(y) # PV(y)
      div = (bCWSy - bCWSx).to_f
       # div == 0.0 # avoid Infinity operation
      return  x + ( ( ev_t - bCWSx).to_f / div )
    end


    def to_complete_schedule_performance_index_pd
      es_to_complete_performance_index
    end
  
    def to_complete_schedule_performance_index_ieac
      es_estimated_to_complete_performance_index
    end


    def es_schedule_variance
      earned_schedule - current_period
    end

    def es_schedule_performance_index
      earned_schedule / current_period
    end

    #  PD = Planned Duration (planned project duration)
    def es_planned_duration
      last_period
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

    def es_to_complete_performance_index #
      # TSPI = (PD-ES)/(PD-AT)
      (es_planned_duration - earned_schedule) / (es_planned_duration - current_period)
    end

    def es_estimated_to_complete_performance_index
      # TSPI= (PD-ES)/(ED-AT)
      (es_planned_duration - earned_schedule) / (es_estimated_duration - current_period)
    end

    #  ED = Estimated Duration (estimated project duration)
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
      result = es_start_date + (es_independent_time_estimate_at_compete * period_duration).days
      earned_schedule.to_f
      # byebug
      result
    end

    def estimated_completion_date_es_to_date
      es_to_date(es_independent_time_estimate_at_compete)
    end

    def earned_schedule(date=nil)
      self.class.find_and_read(self, :earned_schedule, date)
    end

    def set_earned_schedule
      self.earned_schedule = calculate_earned_schedule
    end

    before_save do
      set_earned_schedule
    end
  end

  module ClassMethods
  end
end
