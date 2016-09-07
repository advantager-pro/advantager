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

      before_save :binding_status, :binding_actual_dates, :binding_done_ratio

      def binding_status
        return if milestone?
        return unless (status_was.present? && self.status != status_was)
        if was_closed? && status.in_progress?
          self.actual_due_date = nil
          self.done_ratio = in_progress_done_ratio
        elsif status_was.initial? && status.in_progress?
          self.actual_start_date = Date.today
          self.done_ratio = in_progress_done_ratio
        elsif status.is_closed?
          self.actual_due_date = ::Date.today if self.actual_due_date.nil?
          self.done_ratio = 100
        end
      end

      def binding_actual_dates
        return if milestone?
        if self.actual_start_date_changed? &&
          self.actual_start_date.present?
          if status.initial? && ::IssueStatus.find_in_progress_status.present?
            self.status = ::IssueStatus.find_in_progress_status
          end
          self.done_ratio = in_progress_done_ratio
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
          self.actual_due_date = ::Date.today if self.actual_due_date.nil?
        elsif done_ratio_in_progress?
          if status.initial? && ::IssueStatus.find_in_progress_status.present?
            self.status = ::IssueStatus.find_in_progress_status
          end
          self.actual_start_date = ::Date.today if self.actual_start_date.nil?
        end
      end

      def update_parent_status
        return if self.parent_id.nil?
        ip_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_in_progress")).first.id
        closed_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_closed")).first.id
        new_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_new")).first.id
        rej_status = ::IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first.id

        parent = self.parent
        childs = ::Issue.where(parent_id: self.parent_id)

        childs_closed = childs.where(status_id: closed_status)
        childs_rejected = childs.where(status_id: rej_status)
        childs_in_pro = childs.where(status_id: ip_status)
        childs_new = childs.where(status_id: new_status)
        #raise ({ ip_status: ip_status, closed_status: closed_status, new_status: new_status, rej_status: rej_status, childs: childs, childs_new: childs_new, childs_in_pro: childs_in_pro, childs_closed: childs_closed, childs_rejected: childs_rejected }).inspect

        if childs_in_pro.count > 0
          parent.status_id = ip_status
        elsif childs_closed.count == childs.count || childs.count == (childs_closed.count + childs_rejected.count)
          parent.status_id = closed_status
        elsif childs_rejected.count == childs.count
          parent.status_id = rej_status
        elsif childs_new.count == childs.count
          parent.status_id = new_status
        end
        parent.save(:validate => false)
      end

      def milestone?
        self.tracker.name == I18n.t!("default_tracker_milestone")
      end

      #handle_asynchronously :update_parent_status

      validate :planned_to_put_in_progress,
        :actual_dates_cannot_be_greater_than_today

      def planned_to_put_in_progress
        will_be_in_progress = done_ratio_in_progress? ||
          (actual_start_date.present? && actual_start_date <= Date.today) ||
          status.in_progress? || status.is_closed?
        if (!planned?) && will_be_in_progress
          message = I18n.t!("activerecord.errors.messages.cannot_start_issue_if_not_planned")
          errors.add(:start_date, message)
          errors.add(:due_date, message)
          errors.add(project.issue_evm_field, message)
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

      def not_rejected
        rejected_status_id = ::IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first.id
        tbn = self.table_name
        self.where("#{tbn}.status_id != ?",rejected_status_id)
      end

      def planned_only
        tbn = self.table_name
        self.where("#{tbn}.due_date IS NOT NULL AND #{tbn}.start_date IS NOT NULL")
      end

    end
end
