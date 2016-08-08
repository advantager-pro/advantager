module EVM::ProjectMethods
    extend ActiveSupport::Concern

    include ::EVM::Methods
    included do
      def _budget_at_conclusion
          sum = 0.0
          endate = self.due_date || (Date.today + 1.day)
          # TODO: use SUM here. In the other methods you cannot
          #   use SUM because they use the date param
          issues.not_rejected.planned_only.each{ |e| sum += e.planned_value(endate) }
          sum
      end

      def planned_value(date=nil)
          sum = 0.0
          # We don't need issues that we didn't planned to start
          if date.nil?
            issues.not_rejected.planned_only.each{ |e| sum += e.planned_value }
          else
            issues.not_rejected.planned_only.where("#{::Issue.table_name}.start_date <= ?",
              date).each{ |e| sum += e.planned_value(date) }
          end
          sum
      end

      def actual_cost(date=nil)
          sum = 0.0
          date ||= Date.today
          # We only need issues that are in progress or finished
          issues.not_rejected.planned_only.where("#{::Issue.table_name}.actual_start_date <= ?",
            date).each{ |e| sum += e.actual_cost(date) }
          sum
      end

      def earned_value(date=nil)
          sum = 0.0
          date ||= Date.today
          # We only need issues that are in progress or finished
          issues.not_rejected.planned_only.where("#{::Issue.table_name}.actual_start_date <= ?",
            date).each{ |e| sum += e.earned_value(date) }
          sum
      end

      def create_minimum_break_points
        ::EVM::BreakPoint.create_minimum(self, self.created_on)
      end
      def try_to_update_break_points
        if evm_frequency_changed?
          td = Date.today
          evm_break_points.destroy_all
          ::EVM::BreakPoint.generate_until(self, td)
          ::EVM::BreakPoint.create_minimum(self, td)
        end
      end
      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
      after_create :create_minimum_break_points
      after_update :try_to_update_break_points

      handle_asynchronously :create_minimum_break_points
      handle_asynchronously :try_to_update_break_points
    end

    module ClassMethods
      def store_all_projects_status
        self.all.each do |project|
          ::EVM::Point.update_current_point!(project)
        end
      end
      def store_all_projects_status_ahead(ahead_days=5)
        ahead_days = ahead_days.days
        self.all.each do |project|
          last_point_day = project.evm_points.order("day ASC").last.day
          ::EVM::Point.generate_from_project_begining(project, (last_point_day + ahead_days), last_point_day)
        end
      end
    end
end