module EVM::ActualCostEntry
    extend ActiveSupport::Concern

    included do
      alias_attribute :actual_time, :hours

      ::Project.available_fields.each do |field|
        validates ::Project.entry_field(field), presence: true, if: "project.evm_#{field}_based?", numericality: { greater_than: 0 }
        safe_attributes ::Project.entry_field(field).to_s
      end

    end

    module ClassMethods
    end
end
