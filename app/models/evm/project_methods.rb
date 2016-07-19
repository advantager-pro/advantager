module EVM::ProjectMethods
    extend ActiveSupport::Concern

    include ::EVM::Methods
    included do
      def _budget_at_conclusion
        Rails.cache.fetch("#{cache_key}/budget_at_conclusion", expires_in: 5.minutes) do
          sum = 0.0
          issues.each{ |e| sum += e.planned_value }
          sum
        end
      end

      def planned_value
        Rails.cache.fetch("#{cache_key}/planned_value", expires_in: 5.minutes) do
          sum = 0.0
          issues.where("#{::Issue.table_name}.due_date <= ?", Date.today).each{ |e| sum += e.planned_value }
          sum
        end
      end

      def actual_cost
        Rails.cache.fetch("#{cache_key}/actual_cost", expires_in: 5.minutes) do
          sum = 0.0
          issues.each{ |e| sum += e.actual_cost }
          sum
        end
      end

      def earned_value
        Rails.cache.fetch("#{cache_key}/earned_value", expires_in: 5.minutes) do
          sum = 0.0
          issues.each{ |e| sum += e.earned_value }
          sum
        end
      end

      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
      after_create do
        ::EVM::BreakPoint.create_minimum(self, self.created_on)
      end

      after_update do
        if evm_frequency_changed?
          td = Date.today
          evm_break_points.destroy_all
          ::EVM::BreakPoint.generate_until(self, td)
          ::EVM::BreakPoint.create_minimum(self, td)
        end
      end
    end

    module ClassMethods
      def store_all_projects_status
        self.all.each do |project|
          ::EVM::Point.update_current_point!(project)
        end
      end
    end
end
