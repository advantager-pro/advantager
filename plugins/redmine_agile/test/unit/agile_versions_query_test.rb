# encoding: utf-8
#
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

require File.expand_path('../../test_helper', __FILE__)

class AgileVersionsQueryTest < ActiveSupport::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issue_statuses,
           :issues,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  def setup
    super
    RedmineAgile.create_issues
    @query = AgileVersionsQuery.new
        @query.project = Project.find(2)
    @backlog_version = Version.find(7)
    @current_version = Version.find(5)
    User.current = User.find(1) #because issues selected according permissions
  end

  def test_backlog_version
    assert_equal @backlog_version, @query.backlog_version
  end

  def test_current_version
    assert_equal @current_version, @query.current_version
  end

  def test_backlog_issues
    assert_equal [100,101,102,103], @query.backlog_version_issues.map(&:id).sort
  end
  
  def test_current_issues
    assert_equal [104], @query.current_version_issues.map(&:id).sort
  end
end
