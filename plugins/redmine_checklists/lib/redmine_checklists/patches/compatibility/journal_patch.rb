# This file is a part of Redmine Checklists (redmine_checklists) plugin,
# issue checklists management plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_checklists is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_checklists is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_checklists.  If not, see <http://www.gnu.org/licenses/>.


require_dependency 'journal'

module RedmineChecklists
  module Patches
    module JournalPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
        end
      end

      module InstanceMethods

        if Redmine::VERSION.to_s < '2.6'
          def send_notification
            if notify? &&
                (Setting.notified_events.include?('issue_updated') ||
                  (Setting.notified_events.include?('issue_note_added') && notes.present?) ||
                  (Setting.notified_events.include?('issue_status_updated') && new_status.present?) ||
                  (Setting.notified_events.include?('issue_priority_updated') && new_value_for('priority_id').present?)
                )
              Mailer.issue_edit(self).deliver
            end
          end

          def detail_for_attribute(attribute)
            details.detect {|detail| detail.prop_key == attribute}
          end
        end
      end

    end
  end
end

unless Journal.included_modules.include?(RedmineChecklists::Patches::JournalPatch)
  Journal.send(:include, RedmineChecklists::Patches::JournalPatch)
end
