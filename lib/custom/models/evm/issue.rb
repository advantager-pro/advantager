module EVM::IssueM
    extend ActiveSupport::Concern

    included do
      alias_attribute :estimated_time, :estimated_hours

      ( ::Project.available_fields + [:estimated_hours] ).each do |field|
        validates Project.issue_field(field), numericality: { greater_than: 0, allow_nil: true }
        safe_attributes Project.issue_field(field).to_s

        define_method ::Project.issue_field(field) do
          read_attribute(::Project.issue_field(field)) || 0
        end
      end

    end

    module ClassMethods
    end
end
