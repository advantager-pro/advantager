module Advantager::Issue
    extend ActiveSupport::Concern

    included do
      include Advantager::EVM::Issue

      def in_progress_done_ratio
        ::IssueStatus.find_in_progress_status.try(:default_done_ratio) || 0
      end

      def done_ratio_in_progress?
        return false if done_ratio.nil?
        done_ratio >= in_progress_done_ratio &&
        done_ratio > 0
      end

      def done_ratio_closed?
        return false if done_ratio.nil?
        done_ratio == 100
      end

      before_validation :binding_status,
                        :binding_actual_dates,
                        :binding_done_ratio,
                        :reset_milestone_values
                        
      before_save :reset_milestone_values

      def reset_milestone_values
        if self.milestone?
          ( ::Project.available_fields  ).each do |field|
            self.send(:"#{::Project.issue_field(field)}=", nil)
          end
        end
      end

      def binding_status
        return if milestone?
        if status.present? && status.is_closed? && self.status != status_was
          self.actual_start_date = ::Date.today if self.actual_start_date.nil?
          self.actual_due_date = ::Date.today if self.actual_due_date.nil?
          self.done_ratio = 100
        else
          return unless (status_was.present? && self.status != status_was)
          if was_closed? && status.in_progress?
            self.actual_due_date = nil
            self.actual_start_date = ::Date.today if self.actual_start_date.nil?
            self.done_ratio = in_progress_done_ratio
          elsif status_was.initial? && status.in_progress?
            self.actual_start_date = Date.today if self.actual_start_date.nil?
            self.done_ratio = in_progress_done_ratio
          end
        end
      end

      def binding_actual_dates
        return if milestone?
        if self.actual_start_date_changed? &&
          self.actual_start_date.present?
          if status.initial? && ::IssueStatus.find_in_progress_status.present?
            self.status = ::IssueStatus.find_in_progress_status
          end
          self.done_ratio = in_progress_done_ratio if self.done_ratio == 0
        end
        if self.actual_due_date_changed? &&
          self.actual_due_date.present? && self.actual_due_date <= ::Date.today
          closed_status = ::IssueStatus.where(is_closed: true).first
          self.status = closed_status unless closed_status.nil?
          self.done_ratio = 100
        end
      end

      def binding_done_ratio
        return if milestone?
        return unless done_ratio_changed?
        if done_ratio_closed?
          closed_status = ::IssueStatus.where(is_closed: true).first #check if having rejected as is_closed true doesnt affect to this
          self.status = closed_status
          self.actual_start_date = ::Date.today if self.actual_start_date.nil?
          self.actual_due_date = ::Date.today if self.actual_due_date.nil?
        elsif done_ratio_in_progress?
          if status.initial? && ::IssueStatus.find_in_progress_status.present?
            self.status = ::IssueStatus.find_in_progress_status
          end
          self.actual_start_date = ::Date.today if self.actual_start_date.nil?
        end
      end

      def _update_parent_status
        return if self.parent_id.nil?
        #for some reason when using find_by this gives nil
        ip_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_in_progress")).first
        closed_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_closed")).first
        new_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_new")).first
        rej_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first

        childs = ::Issue.where(parent_id: self.parent_id)

        childs_closed = childs.where(status: closed_status)
        childs_rejected = childs.where(status: rej_status)
        childs_in_pro = childs.where(status: ip_status)
        childs_new = childs.where(status: new_status)

        if childs_in_pro.count > 0
          self.parent.status = ip_status
        elsif childs_closed.count == childs.count || childs.count == (childs_closed.count + childs_rejected.count)
          self.parent.status = closed_status
        elsif childs_rejected.count == childs.count
          self.parent.status = rej_status
        elsif childs_new.count == childs.count || childs.count == (childs_rejected.count + childs_new.count)
          self.parent.status = new_status
        else
          self.parent.status = ip_status
        end
        self.parent.save(:validate => false) #this has to be validate false because it doesnt update if not
      end

      def update_parent_status
        self.delay._update_parent_status
      end

      def milestone?
        self.tracker.name == I18n.t!("default_tracker_milestone")
      end

      def meeting?
        self.tracker.name == I18n.t!("default_tracker_meeting")
      end

      validate :required_fields_to_put_in_progress_or_close,
        :actual_dates_cannot_be_greater_than_today

      def required_fields_to_put_in_progress_or_close
        return if milestone?
        will_be_in_progress_or_closed = done_ratio_in_progress? ||
          (actual_start_date.present? && actual_start_date <= Date.today) ||
          status.in_progress? || status.is_closed?
        if will_be_in_progress_or_closed
          message = I18n.t!("activerecord.errors.messages.cannot_change_status_if_blank", status: status.name)
          required_fields = %w(start_date actual_start_date due_date)
          required_fields << 'actual_due_date' if status.is_closed?
          required_fields << project.issue_evm_field
          required_fields.each do |field|
            errors.add(field, message) if self.send(field).nil?
          end
        end
      end

      def actual_dates_cannot_be_greater_than_today
        if actual_due_date.present? && actual_due_date > Date.today
         errors.add(:actual_due_date,
          I18n.t!("activerecord.errors.messages.cannot_be_greater_than_today"))
        end
        if actual_start_date.present? && actual_start_date > Date.today
         errors.add(:actual_start_date,
          I18n.t!("activerecord.errors.messages.cannot_be_greater_than_today"))
        end
      end

    end

    module ClassMethods

      def tasks
        self.where(tracker_id: ::Tracker.where(name: I18n.t!("default_tracker_task")).first.id)
      end

      def not_rejected
        rejected_status_id = ::IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first.id
        tbn = self.table_name
        self.where("#{tbn}.status_id != ?",rejected_status_id)
      end

      def planned_only
        tbn = self.table_name
        self.where("#{tbn}.due_date IS NOT NULL AND #{tbn}.start_date IS NOT NULL")
      end

      def for_evm
        not_rejected.planned_only.tasks
      end
    end
end
