module Advantager::EarnedSchedule

  def start_date
    project.start_date
  end

  def period_duration
    project.evm_frequency
  end

  def current_period
    ( (Date.today - start_date) / period_duration ).to_i
  end

  def to_date(period)
    period * period_duration
  end

  def to_period(date)
    date / period_duration
  end

  def BCWP(period)
    project.earned_value(to_date(period))
  end

  def BCWS(period)
    project.planned_value(to_date(period))
  end

  def find_period_x(period)
    period ||= current_period
    periods.reverse.select{ |x| BCWP(period) >= BCWS(x) }
  end

  # Point in period when current progress was planned to occur
  def earned_schedule_cu(period)
    # Earned Schedule =
    # Whole months completed were Σ BCWP ≥ Σ BCWS + fractional month
    # completed
    # = Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
    # (X = whole month earned; Y = month following X; T = Actual TIme)
    # x = whole_month_earned
    # y = next_month
    # t = actual_time

    # Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
    # x = whole month earned; y = month following x; t = Actual Time (Time Now)


    t = actual_time(period)
    x = find_period_x(t)
    BCWSx = BCWS(x)
    y =  x + 1
    return  x + ( (BCWP(t) - BCWSx) / (BCWP(y) - BCWSx)  )
  end

  def schedule_variance(period=nil)
    earned_schedule(period) - actual_time(period)
  end

  def schedule_performance_index(period)
    earned_schedule(period) / actual_time(period)
  end

  def actual_time(period)
    # AT is “Actual Time” – the duration from start to the duration
    #  from start to period now
    period || current_period
    #  for example: 10 months
  end


  #  PD = Planned Duration (planned project duration)
  def planned_duration(period)
    # why would you use period here?

    # Planned project duration
    # Total PV or amount of periods?
    project.end_date # this ?
    to_period(project.end) # or this?
  end

  # Remaining work
  def planned_duration_work_remaining(period)
    # PDWR= PD-EScum
    planned_duration(period) - earned_schedule(period)
  end

  def estimate_at_complete1(period) # basic
    # EAC(t) = PD/SPI(t)
    planned_duration / schedule_performance_index(period)
  end

  def estimate_at_complete2(period) # complex (?)
    # EAC(t)(2) = AT+(PD-ES)/SPI(t)
    actual_time + (planned_duration - earned_schedule) / schedule_performance_index(period)
  end

  def to_complete_performance_index1 #
    # TSPI = (PD-ES)/(PD-AT)
    (planned_duration - earned_schedule) / (planned_duration - actual_time)
  end

  def to_complete_performance_index2
    # TSPI= (PD-ES)/(ED-AT)
    (planned_duration - earned_schedule) / (estimated_duration - actual_time)
  end

  #  ED = Estimated Duration (estimated project duration)
  def estimated_duration(period)
    # period ?
    planned_duration / schedule_performance_index(period)
    #  estimated_duration seems to be = independent_estimate_at_compete
    # estimated_duration example value: 30 months
  end

  def independent_estimate_at_compete(period)
    planned_duration(period) / schedule_performance_index(period)
  end

  # PCD = Planned Completion Date (Planned project end date)
  def planned_completion_date
    project.end_date
  end

  # ECD = Estimated Completion Date (Estimated project end date)
  def estimated_completion_date
    start_date + estimated_duration
  end
end
