module Advantager::EVM::ProjectMethods
    extend ActiveSupport::Concern

    include ::Advantager::EVM::Methods
    included do
      def _budget_at_conclusion(date=nil)
        if date.nil?
          issues.for_evm.sum(::Project.issue_field(evm_field))
        else
          # The BAC for a given date is equal to the accumulative
          # planned value for that same date
          planned_value(date)
        end
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

      def recalculate_evm_points_by_date(min_date: , max_date:)
        affected_points = self.evm_points.by_day_range(start_date: min_date, end_date: max_date)
        affected_points.find_each { |evm_point| evm_point.save! }
      end

      # TODO: check why we are not using this validation
      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
    end

    module ClassMethods
      def store_all_projects_status
        self.all.each do |project|
          ::Advantager::EVM::Point.update_current_point!(project)
        end
      end
    end
end
