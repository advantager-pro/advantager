module EVM::IssuePV
    extend ActiveSupport::Concern

    included do
      alias_attribute :estimated_time, :estimated_hours

      ( ::Project.available_fields  ).each do |field|
        validates Project.issue_field(field), numericality: { greater_than: 0, allow_nil: true }
        safe_attributes Project.issue_field(field).to_s

        #  This won't work beacuse when you create a new issue its default value will be 0
        # And the validation above says it shouldn't be 0
        # define_method ::Project.issue_field(field) do
        #   read_attribute(::Project.issue_field(field)) || 0
        # end
      end

    end

    module ClassMethods
    end
end
