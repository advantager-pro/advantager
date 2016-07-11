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

require_dependency 'project'

module RedmineChecklists
  module Patches

    module ProjectPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method_chain :copy_issues, :checklist

        end
      end

      module InstanceMethods

        def copy_issues_with_checklist(project)
          copy_issues_without_checklist(project)
          issues.each{ |issue| issue.copy_checklists(issue.copied_from)}
        end

      end

    end

  end
end


unless Project.included_modules.include?(RedmineChecklists::Patches::ProjectPatch)
  Project.send(:include, RedmineChecklists::Patches::ProjectPatch)
end
