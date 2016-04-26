# This file is a part of Redmin Agile (redmine_agile) plugin,
# Agile board plugin for redmine
#
# Copyright (C) 2011-2016 RedmineCRM
# http://www.redminecrm.com/
#
# redmine_agile is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_agile is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_agile.  If not, see <http://www.gnu.org/licenses/>.

module RedmineAgile
  module Patches

    module ProjectPatch
      def self.included(base)
        base.class_eval do
          unloadable
          acts_as_colored
          safe_attributes 'agile_color_attributes',
            :if => lambda {|project, user| user.allowed_to?(:edit_project, project) && user.allowed_to?(:view_agile_queries, project) && RedmineAgile.use_colors?}
        end
      end
    end

  end
end

unless Project.included_modules.include?(RedmineAgile::Patches::ProjectPatch)
  Project.send(:include, RedmineAgile::Patches::ProjectPatch)
end
