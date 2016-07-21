module Advantager::Issue
    extend ActiveSupport::Concern

    included do

      def done_ratio_in_progress?
        done_ratio >= ::IssueStatus.find_in_progress_status.default_done_ratio
      end

      def done_ratio_closed?
        done_ratio == 100
      end

      before_save :binding_status, :binding_actual_dates, :binding_done_ratio

      def binding_status
        return unless (status_was.present? && self.status != status_was)
        if was_closed? && status.in_progress?
          self.actual_due_date = nil
          self.done_ratio = ::IssueStatus.find_in_progress_status.default_done_ratio
        elsif status_was.initial? && status.in_progress?
          actual_start_date = Date.today
          done_ratio = ::IssueStatus.find_in_progress_status.default_done_ratio
        end
      end

      def binding_actual_dates
        return unless actual_start_date_changed? ||
          actual_due_date_changed?
        if self.actual_due_date <= ::Date.today
          in_progress_status = ::IssueStatus.find_in_progress_status
          self.status = in_progress_status if status.initial?
          self.done_ratio = in_progress_status.default_done_ratio
        elsif self.actual_due_date <= ::Date.today
          closed_status = ::IssueStatus.where(is_closed: true).first
          self.status = closed_status
          self.done_ratio = 100
        end
      end

      def binding_done_ratio
        return unless done_ratio_changed?
        if done_ratio_in_progress?
          self.status = ::IssueStatus.find_in_progress_status if status.initial?
          self.actual_start_date = ::Date.today if self.actual_start_date.nil?
        elsif done_ratio_closed?
          closed_status = ::IssueStatus.where(is_closed: true).first
          self.status = closed_status
          self.actual_due_date = ::Date.today if self.actual_due_date.nil?
        end
      end

    end

    module ClassMethods
      def not_rejected
        rejected_status_id = ::IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first.id
        self.where("status_id != ?",rejected_status_id)
      end
    end
end
