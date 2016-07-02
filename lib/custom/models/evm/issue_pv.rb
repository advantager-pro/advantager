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

      def planned_value
        self.send(project.issue_evm_field)
      end

      def actual_cost
        ac = 0
        time_entries.each{ |e| ac += e.actual_cost }
        ac
      end

      def earned_value
        (done_ratio/100.0) * planned_value
      end

    end

    module ClassMethods
    end
end
