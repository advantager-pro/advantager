module EVMHelper


  def evm_unity(project, field=nil)
    field ||= project.evm_field
    field == 'cost' ? Money::Currency.find(project.currency).symbol : ( field == 'custom' ? project.custom_unity : t("evm.unities.#{field}"))
  end

  def evm_entry_unity(entry, field)
    return  '' if field == 'time' || field == 'point'
    evm_unity(entry.project, field)
  end

  def entry_field_value val
    val || 0.0
  end

  def sum_evm_values values, field
    values.reduce{ |sum, e|  sum + e.send(field).to_f }
  end

end
