module EVM::ActualCostEntry
    extend ActiveSupport::Concern

    included do
      alias_attribute :actual_time, :hours

      (::Project.available_fields + [:hours]).each do |field|
        validates ::Project.entry_field(field), presence: true, if: "project.evm_#{field}_based?", numericality: { greater_than: 0 }
        safe_attributes ::Project.entry_field(field).to_s

        # This won't work beacuse when you create a new time entry its default value will be 0
        # And the validation above says it shouldn't be 0
        # define_method ::Project.entry_field(field) do
        #   read_attribute(::Project.entry_field(field)) || 0
        # end
      end

      def actual_cost
        self.send(project.entry_evm_field)
      end

    end

    module ClassMethods
    end
end
