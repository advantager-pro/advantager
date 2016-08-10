module EVM::Issue
    extend ActiveSupport::Concern

    included do
      alias_attribute :estimated_time, :estimated_hours

      ( ::Project.available_fields  ).each do |field|
        validates Project.issue_field(field), numericality: { greater_than: 0, allow_nil: true }
        safe_attributes Project.issue_field(field).to_s

        #  This won't work beacuse when you create a new issue its default value will be 0
        # And the validation above says it shouldn't be 0
        # define_method ::Project.issue_field(field) do
        #   read_attribute(::Project.issue_field(field)) || 0
        # end
      end


      # Evm::Point.find_or_initialize_by(project: ::Project.last, day: (Date.today - 4.days)).save!
      #
      # # Set actual_start_date
      # Issue.all.each{ |i|  i.actual_start_date = i.journals.first.try(:created_on) || i.start_date || i.created_on  }
      #
      # Project.last.evm_points.destroy_all ; EVM::Point.generate_from_project_begining(Project.last)


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
        if date.nil? || date == Date.today
          time_entries.sum(entry_ac_field)
        else
          time_entries.where("#{::TimeEntry.table_name}.created_on <= ?",
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

      def try_to_update_planned_value
        if self.send(:"#{project.issue_evm_field}_changed?")
          project.evm_points.each do |evm_point|
            evm_point.set_planned_value
            evm_point.save!
          end
        end
      end

      def planned?
        start_date.present? && due_date.present? &&
          self.send(project.issue_evm_field).present?
      end

      def recalculate_project_evm_points
        project.recalculate_evm_points if self.planned?
      end

      before_destroy :recalculate_project_evm_points
      after_update :try_to_update_planned_value

      handle_asynchronously :recalculate_project_evm_points
      handle_asynchronously :try_to_update_planned_value
    end

    module ClassMethods
    end
end
