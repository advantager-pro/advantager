module Advantager::EarnedSchedule

  def earned_value(t)
  end

  def BCWP(t)
    earned_value(t)
  end

  def BCWS(x)
    planned_value(x)
  end

  def sumBCWP
    BCWP(until_now)
  end

  def sumBCWS
    BCWS(until_now)
  end

  def planned_value(period)

  end

  def month_x(period)
    period ||= current_period
    periods.reverse.select{ |x| sumBCWP(period) >= sumBCWP(x) }
  end

  def earned_schedule_cu(period)
    # Earned Schedule =
    # Whole months completed were Σ BCWP ≥ Σ BCWS + fractional month
    # completed
    # = Month (X) + [(Σ BCWPt– Σ BCWSx) ÷ (Σ BCWSy – Σ BCWSx)]
    # (X = whole month earned; Y = month following X; T = Actual TIme)
    # x = whole_month_earned
    # y = next_month
    # t = actual_time
    period ||= current_period
    x = month_x(period)
    BCWSx = sumBCWS(x)
    y =  x + 1
    return  x + ( (sumBCWP(period) - BCWSx) / (sumBCWP(y) - BCWSx)  )
  end

  def schedule_variance(time=nil)
    earned_schedule(time) - actual_time(time)
  end

  def schedule_performance_index(time)
    earned_schedule(time) / actual_time(time)
  end

  def actual_time
  end

  def planned_duration
  end

  def independent_estimate_at_compete(time)
    planned_duration(time) / schedule_performance_index(time)
  end

  def earned_schedule_mo(period)
    period + i(period)
  end

  def i(period)
    (earned_value - planned_value(period)) / (planned_value(period+1) - planned_value(period))
  end

end
