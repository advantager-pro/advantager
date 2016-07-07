module EVM::ProjectMethods
    extend ActiveSupport::Concern

    include EVM::Methods
    included do
      def _budget_at_conclusion
        Rails.cache.fetch("#{cache_key}/budget_at_conclusion", expires_in: 5.minutes) do
          sum = 0
          issues.each{ |e| sum += e.planned_value }
          sum
        end
      end

      def planned_value
        Rails.cache.fetch("#{cache_key}/planned_value", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.planned_value
        end
      end

      def actual_cost
        Rails.cache.fetch("#{cache_key}/actual_cost", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.actual_cost
        end
      end

      def earned_value
        Rails.cache.fetch("#{cache_key}/earned_value", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.earned_value
        end
      end

      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
      after_create do
        Evm::BreakPoint.create_minimum(self, self.created_at)
      end

      after_update do
        if evm_frequency.has_changed?
          today = Date.today
          break_points.destroy_all
          Evm::BreakPoint.generate_until(self, today)
          Evm::BreakPoint.create_minimum(self, today)
        end
      end
    end

    module ClassMethods
    end
end
