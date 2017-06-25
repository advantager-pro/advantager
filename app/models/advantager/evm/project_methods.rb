module Advantager::EVM::ProjectMethods
    extend ActiveSupport::Concern

    include ::Advantager::EVM::Methods
    included do
      def _budget_at_conclusion
        issues.for_evm.sum(::Project.issue_field(evm_field))
      end

      def planned_value(date)
        sum = 0.0
        # We don't need issues that we didn't planned to start
        issues.for_evm.where("#{::Issue.table_name}.start_date <= ?",
          date).each{ |e| sum += e.planned_value(date) }
        sum
      end

      def actual_cost(date)
        sum = 0.0
        # We only need issues that are in progress or finished
        issues.for_evm.where("#{::Issue.table_name}.actual_start_date <= ?",
          date).each{ |e| sum += e.actual_cost(date) }
        sum
      end

      def earned_value(date)
        sum = 0.0
        # We only need issues that are in progress or finished
        issues.for_evm.where("#{::Issue.table_name}.actual_start_date <= ?",
          date).each{ |e| sum += e.earned_value(date) }
        sum
      end

      def most_recent_point
        self.evm_points.order("day ASC").last
      end

      def most_recent_point_day
        most_recent_point.day
      end

      def first_point_day
        self.evm_points.order("day ASC").first.day
      end

      def recalculate_evm_points
        ::Advantager::EVM::Point.generate_from_project_begining(self, self.most_recent_point_day, self.first_point_day)
      end

      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }

      handle_asynchronously :recalculate_evm_points
    end

    module ClassMethods
      def store_all_projects_status
        self.all.each do |project|
          ::Advantager::EVM::Point.update_current_point!(project)
        end
      end
    end
end
