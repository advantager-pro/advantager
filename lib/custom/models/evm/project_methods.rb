module EVM::ProjectMethods
    extend ActiveSupport::Concern

    included do
      has_many :issues
      has_many :points, through: :issues

      def planned_value
        sum = 0
        issues.each{ |e| sum += e.planned_value }
        sum
      end

      def actual_cost
        sum = 0
        issues.each{ |e| sum += e.actual_cost }
        sum
      end

      def earned_value
        sum = 0
        issues.each{ |e| sum += e.earned_value }
        sum
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

    # def intance_method_x
    # end

    module ClassMethods

    end
end
