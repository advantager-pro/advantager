module EVMHelper


  def evm_unity(project, field=nil)
    field ||= project.evm_field
    field == 'cost' && project.currency.present? ? Money::Currency.find(project.currency).symbol : ( field == 'custom' ? project.custom_unity : t("evm.unities.#{field}"))
  end

  def evm_entry_unity(entry, field)
    return  '' if field == 'time' || field == 'point'
    evm_unity(entry.project, field)
  end

  def entry_field_value val
    val || 0.0
  end

  def sum_evm_values values, field
    sum = 0
    values.each{ |e|  sum + e.send(field).to_f }
    sum
  end

  def emv_points_data(evm_points, field)
    '['+ evm_points.map do |e|
      d = e.day
      "{ x: new Date(#{d.year},#{d.month},#{d.day}), y: #{e.send(field)}}"
    end.join(',').html_safe + ']'
  end

  def data_for_morris(evm_points, options)
    fields = options[:fields]
    project = evm_points.first.project
    n = project.evm_frequency

    pts = (n - 1).step(evm_points.size - 1, n).map do |i|
      e = evm_points[i]
      hash = {}
      fields.each do |field|
        if field == 'day'
            d = e.day
            hash[field] = "#{d.year}-#{d.month}-#{d.day}"
        else
          hash[field] = e.send(field)
        end
      end
      hash
    end
    d = project.due_date
    if d > Date.today && (fields.include?('planned_value') || fields.include?(:planned_value))
      lp = evm_points.last
      pts << { planned_value: lp.budget_at_conclusion, day: "#{d.year}-#{d.month}-#{d.day}" }
    end
    pts.to_json.html_safe
  end

  def evm_break_points_events(project)
    bps = []
    current_date = project.created_on
    last_date = project.due_date
    freq = project.evm_frequency.days
    while last_date > current_date
      bps <<  current_date
      current_date += freq
    end
    bps.to_json.html_safe
  end

end
