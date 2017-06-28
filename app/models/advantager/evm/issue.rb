module Advantager::EVM::Issue
    extend ActiveSupport::Concern

    included do
      alias_attribute :estimated_time, :estimated_hours

      ( ::Project.available_fields  ).each do |field|
        validates ::Project.issue_field(field), numericality: { greater_than: 0, allow_nil: true }
        safe_attributes ::Project.issue_field(field).to_s

        #  This won't work beacuse when you create a new issue its default value will be 0
        # And the validation above says it shouldn't be 0
        # define_method ::Project.issue_field(field) do
        #   read_attribute(::Project.issue_field(field)) || 0
        # end
      end

      def planned_value(date=nil)
        # 9, 19
        pv = self.send(project.issue_evm_field) || 0.0
        start = ( start_date || date )
        due = ( due_date || start )
        return pv if date.nil? || date >= due || due == start || pv == 0.0
        return 0 if start > date
        # 5 - 2 = 3
        # 9 / 3 = 3
        #
        # date 1 -> 2 > 1 : 0
        # date 2 -> 3 - 2 .. 1*3 = 3
        # date 3 -> 3 - 2 .. 2*3 = 6
        # date 4 -> 4 == due : 9
        # date 5 -> 5 > due : 9
        #
        avg = pv / ((due  + 1.day) - start)
        avg*( (date + 1.day) - start )
      end

      def actual_cost(date=nil)
        entry_ac_field = ::Project.entry_field(self.project.evm_field)
        if date.nil? || date == ::Date.today
          time_entries.sum(entry_ac_field)
        else
          time_entries.where("#{::TimeEntry.table_name}.spent_on <= ?",
            date).sum(entry_ac_field)
        end
      end

      def done_ratio_at(date=nil)
        return done_ratio if date.nil? || date == Date.today
        last_journal = journals.joins(:details).
          where("#{::JournalDetail.table_name}.prop_key = 'done_ratio'
            AND #{::Journal.table_name}.created_on <= ?", date).
              order("#{::Journal.table_name}.created_on ASC").last
        return done_ratio if last_journal.nil?
        last_journal.details.where(prop_key: :done_ratio).last.try(:value).to_f
      end

      def earned_value(date=nil)
        total_pv = planned_value(nil)
        (done_ratio_at(date)/100.0) * total_pv
      end

      def update_evm_points
        today = Date.today
        min_date = [start_date, actual_start_date, today].min
        max_date = [due_date, actual_due_date, today].max
        project.recalculate_evm_points_by_date(min_date: min_date, max_date: max_date)
      end

      def planned?
        start_date.present? && due_date.present? &&
          self.send(project.issue_evm_field).present?
      end

      def pv_fields_changed?
        self.send(:"#{project.issue_evm_field}_changed?") || 
          due_date_changed? || start_date_changed?
      end

      def ac_fields_changed?
        actual_due_date_changed? || actual_start_date_changed?
      end

      def evm_fields_changed?
        pv_fields_changed? || ac_fields_changed?
      end

      before_destroy :update_evm_points
      after_update :update_evm_points, if: :evm_fields_changed?

      handle_asynchronously :update_evm_points
    end

    module ClassMethods
    end
end
