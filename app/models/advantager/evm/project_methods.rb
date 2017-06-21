module Advantager::EVM::ProjectMethods
    extend ActiveSupport::Concern

    include ::Advantager::EVM::Methods
    included do
      def _budget_at_conclusion
          sum = 0.0
          endate = self.due_date || (Date.today + 1.day)
          # TODO: use SUM here. In the other methods you cannot
          #   use SUM because they use the date param
          issues.for_evm.each{ |e| sum += e.planned_value(endate) }
          sum
      end

      def planned_value(date=nil)
        # byebug
        sum = 0.0
        # We don't need issues that we didn't planned to start
        if date.nil?
          issues.for_evm.each{ |e| sum += e.planned_value }
        else
          issues.for_evm.where("#{::Issue.table_name}.start_date <= ?",
            date).each{ |e| sum += e.planned_value(date) }
        end
        sum
      end

      def actual_cost(date=nil)
        # byebug
        sum = 0.0
        date ||= Date.today
        # We only need issues that are in progress or finished
        issues.for_evm.where("#{::Issue.table_name}.actual_start_date <= ?",
          date).each{ |e| sum += e.actual_cost(date) }
        sum
      end

      def earned_value(date=nil)
        # byebug
        sum = 0.0
        date ||= ::Date.today
        # We only need issues that are in progress or finished
        issues.for_evm.where("#{::Issue.table_name}.actual_start_date <= ?",
          date).each{ |e| sum += e.earned_value(date) }
        sum
      end

      def last_point
        self.evm_points.order("day ASC").last
      end

      def last_point_day
        last_point.day
      end

      def first_point_day
        self.evm_points.order("day ASC").first.day
      end

      def recalculate_evm_points
        ::Advantager::EVM::Point.generate_from_project_begining(self, self.last_point_day, self.first_point_day)
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
      def store_all_projects_status_ahead(ahead_days=5)
        ahead_days = ahead_days.days
        self.all.each do |project|
          last_point_day = project.last_point_day
          ::Advantager::EVM::Point.generate_from_project_begining(project, (last_point_day + ahead_days), last_point_day)
        end
      end
    end
end
