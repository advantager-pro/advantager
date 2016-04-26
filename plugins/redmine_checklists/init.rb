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

require 'redmine'
require 'redmine_checklists/redmine_checklists'

CHECKLISTS_VERSION_NUMBER = '3.1.3'
CHECKLISTS_VERSION_TYPE = "Light version"

Redmine::Plugin.register :redmine_checklists do
  name "Redmine Checklists plugin (#{CHECKLISTS_VERSION_TYPE})"
  author 'RedmineCRM'
  description 'This is a issue checklist plugin for Redmine'
  version CHECKLISTS_VERSION_NUMBER
  url 'http://redminecrm.com'
  author_url 'mailto:support@redminecrm.com'

  requires_redmine :version_or_higher => '2.1'

  settings :default => {
    :save_log => false,
    :issue_done_ratio => false
  }, :partial => 'settings/checklists/checklists'

  Redmine::AccessControl.map do |map|
    map.project_module :issue_tracking do |map|
      map.permission :view_checklists,            {:checklists => [:show, :index]}
      map.permission :done_checklists,            {:checklists => :done}
      map.permission :edit_checklists,            {:checklists => [:done, :create, :destroy, :update]}
    end
  end

  Redmine::Search.map do |search|
    # search.register :checklists
  end

end
