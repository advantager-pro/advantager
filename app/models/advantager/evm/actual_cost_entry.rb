module Advantager::EVM::ActualCostEntry
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

      def evm_actual_cost
        self.send(project.entry_evm_field) || 0.0
      end

      def update_evm_points
        today = Date.today
        spent_minus = spent_on - 1.day
        spent_plus = spent_on + 1.day 
        min_date = spent_minus < project.start_date ? spent_on : spent_minus
        max_date = spent_plus > today ? today : spent_plus
        project.recalculate_evm_points_by_date(min_date: min_date, max_date: max_date)
      end

      def evm_fields_changed?
        spent_on_changed? || self.send("#{project.entry_evm_field}_changed?")
      end

      before_destroy :update_evm_points
      after_update :update_evm_points, if: :evm_fields_changed?

      handle_asynchronously :update_evm_points
    end

    module ClassMethods
    end
end
