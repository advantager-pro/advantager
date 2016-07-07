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
    '['+ evm_points.sort_by{ |e| e['day'] }.map do |e|
      "{ x: new Date(#{e['day'].year},#{e['day'].month},#{e['day'].day}), y: #{e[field]}}"
    end.join(',').html_safe + ']'
  end

end
