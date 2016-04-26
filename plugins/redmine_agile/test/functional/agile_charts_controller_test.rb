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

class AgileChartsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
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

  def test_get_show
    @request.session[:user_id] = 1
    get :show
    assert_response :success
    assert_template :show
  end

  def test_get_render_chart_issues_burndown_with_version
    @request.session[:user_id] = 1
    get :render_chart, :chart => "issues_burndown", :version_id => 2
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_issues_burndown
    @request.session[:user_id] = 1
    get :render_chart, :chart => "issues_burndown"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_work_burndown
    @request.session[:user_id] = 1
    get :render_chart, :chart => "work_burndown"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_burnup
    @request.session[:user_id] = 1
    get :render_chart, :chart => "burnup"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_work_burnup
    @request.session[:user_id] = 1
    get :render_chart, :chart => "work_burnup"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_trackers_cumulative_flow
    @request.session[:user_id] = 1
    get :render_chart, :chart => "trackers_cumulative_flow"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_cumulative_flow
    @request.session[:user_id] = 1
    get :render_chart, :chart => "cumulative_flow"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_issues_velocity
    @request.session[:user_id] = 1
    get :render_chart, :chart => "issues_velocity"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_lead_time
    @request.session[:user_id] = 1
    get :render_chart, :chart => "lead_time"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_get_render_chart_average_lead_time
    @request.session[:user_id] = 1
    get :render_chart, :chart => "average_lead_time"
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_issues_burndown_chart_when_first_issue_later_then_due_date
    @project_1 = Project.find(1)
    EnabledModule.create(:project => @project_1, :name => 'agile')
    @request.session[:user_id] = 1
    new_version = Version.create!(:name => "Some new vesion", :effective_date => (Date.today - 10.days), :project_id => @project_1.id)
    issue = Issue.create!(:project_id => 1, :tracker_id => 1, :subject => 'test_issues_burndown_chart_when_first_issue_later_then_due_date', :author_id => 2, :start_date => Date.today)
    new_version.fixed_issues << issue
    get :render_chart, :chart => "issues_burndown", :project_id => 1, :version_id => new_version.id
    assert_response :success
  end


end
