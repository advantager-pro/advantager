module EVMHelper

  def req_field(field_key)
    label = I18n.t("field_#{field_key}") || I18n.t("label_#{field_key}")
    "#{label}  *"
  end

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

  def positive_status
    "positive"
  end

  def negative_status
    "negative"
  end

  def neutral_status
    "neutral"
  end

  def critical_status
    "critical"
  end

  
  def sv_status(sv)
    return positive_status if sv > 0 
    return negative_status if sv < 0 
    neutral_status
  end

  def es_sv_status(sv)
    sv_status(sv)
  end

  def cv_status(cv)
    return positive_status if cv > 0 
    return negative_status if cv < 0 
    neutral_status
  end

  def vac_status(vac)
    return positive_status if vac > 0 
    return negative_status if vac < 0 
    neutral_status
  end

  def spi_status(spi)
    return positive_status if spi > 1
    return negative_status if spi < 1
    neutral_status
  end

  def cpi_status(cpi)
    return positive_status if cpi > 1
    return negative_status if cpi < 1
    neutral_status
  end

  def tcpi_status(tcpi)
    return positive_status if tcpi < 1
    return negative_status if tcpi > 1
    neutral_status
  end

  def es_spi_status(spi)
    spi_status(spi)
  end

  def tspi_status(tspi)
    return critical_status if tspi > 1.1
    return negative_status if tspi > 1
    return positive_status if tspi < 1
    neutral_status
  end
end
