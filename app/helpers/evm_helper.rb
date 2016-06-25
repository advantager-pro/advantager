module EVMHelper


  def evm_unity(project)
    field = project.evm_field
    field == 'cost' ? Money::Currency.find(project.currency).symbol : ( field == 'custom' ? project.custom_unity : t("evm.unities.#{field}"))
  end

end
