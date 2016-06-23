module EVM::Issue
    extend ActiveSupport::Concern

    included do
      alias_attribute :estimated_time, :estimated_hours

      ::Project.available_fields.each do |field|
        validates Project.issue_field(field), numericality: { greater_than: 0, allow_nil: true }
        safe_attributes Project.issue_field(field).to_s
      end

    end

    module ClassMethods
    end
end
