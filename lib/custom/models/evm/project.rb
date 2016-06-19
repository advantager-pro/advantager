module EVM::Project

  def self.available_fields
    @@available_fields ||= %w(time, point, cost, custom)
  end

  # validates :evm_field, inclusion: { in: self.available_fields }
  # validates :visible_fields, inclusion: { in: (self.available_fields - [self.evm_field]) }

end
