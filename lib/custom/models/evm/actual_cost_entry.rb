module EVM::ActualCostEntry
    extend ActiveSupport::Concern

    included do
      alias_attribute :actual_time, :hours

      Project.available_fields.each do |field|
        validates :"actual_#{field}", presence: true, if: "project.evm_#{field}_based?"
      end

      safe_attributes 'actual_point', 'actual_cost', 'actual_custom', 'hours'
    end

    module ClassMethods
    end
end
