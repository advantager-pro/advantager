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

module RedmineChecklists
  module Patches

    module IssuesControllerPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          alias_method_chain :build_new_issue_from_params, :checklist
          before_filter :save_before_state, :only => [:update]
        end


      end

      module InstanceMethods

        def build_new_issue_from_params_with_checklist
          if params[:copy_from] && params[:id].blank? && params[:issue].blank?
            params[:issue] = {:checklists_attributes => {}}
            begin
                @copy_from = Issue.visible.find(params[:copy_from])
                @copy_from.checklists.each_with_index do |checklist_item, index|
                  params[:issue][:checklists_attributes][index.to_s] = {:is_done => checklist_item.is_done,
                                                                        :subject => checklist_item.subject,
                                                                        :position => checklist_item.position}
                end
            rescue ActiveRecord::RecordNotFound
              render_404
              return
            end
          end
          build_new_issue_from_params_without_checklist
        end

        def save_before_state
          @issue.old_checklists = @issue.checklists.to_json
        end
      end

    end

  end
end


unless IssuesController.included_modules.include?(RedmineChecklists::Patches::IssuesControllerPatch)
  IssuesController.send(:include, RedmineChecklists::Patches::IssuesControllerPatch)
end
