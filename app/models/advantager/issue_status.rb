module Advantager::IssueStatus
    extend ActiveSupport::Concern

    included do
      def in_progress?
        name == I18n.t!("default_issue_status_in_progress")
      end

      def initial?
        name == I18n.t!("default_issue_status_new")
      end
    end

    module ClassMethods
      def find_in_progress_status
        self.where(name: I18n.t!("default_issue_status_in_progress")).first
      end
    end
end
