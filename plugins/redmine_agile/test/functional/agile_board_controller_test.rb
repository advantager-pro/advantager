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

class AgileBoardsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :issue_relations,
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
  fixtures :email_addresses if Redmine::VERSION.to_s > '3.0'

  def setup
    @project_1 = Project.find(1)
    @project_2 = Project.find(5)
    EnabledModule.create(:project => @project_1, :name => 'agile')
    EnabledModule.create(:project => @project_2, :name => 'agile')
    @request.session[:user_id] = 1
  end

  def test_get_index
    # global board
    get :index
    assert_response :success
    assert_template :index
    assert_equal Issue.open.map(&:id).sort, assigns[:issues].map(&:id).sort
    assert_select ".issue-card", Issue.open.count
  end

  def test_get_index_with_project
    get :index, :project_id => @project_1
    issues = Issue.where(:project_id => [@project_1] + Project.where(:parent_id => @project_1.id).to_a,
      :status_id => IssueStatus.where(:is_closed => false))
    assert_equal issues.map(&:id).sort, assigns[:issues].map(&:id).sort
    assert_select ".issue-card", issues.count
    assert_select ".issue-card span.fields p.issue-id strong", issues.count
    assert_select ".issue-card span.fields p.name a", issues.count
  end

  def test_get_index_truncated
    with_agile_settings "board_items_limit" => 1 do
      get :index, agile_query_params
      assert_response :success
      assert_template :index
      assert_select 'div#content p.warning', 1
      assert_select 'td.issue-status-col .issue-card', 1
    end
  end

  def test_limit_for_truncated
    expected_issues = Issue.where(:project_id => [@project_1] + Project.where(:parent_id => @project_1.id).to_a,
      :status_id => IssueStatus.where(:is_closed => false))
    with_agile_settings "board_items_limit" => (expected_issues.count + 1) do
      get :index, agile_query_params.merge({:f_status => IssueStatus.where(:is_closed => false).pluck(:id)})
      assert_response :success
      assert_template :index
      assert_select 'div#content p.warning', 0
    end
  end if Redmine::VERSION.to_s > '2.4'

  def test_get_index_with_filters
    if Redmine::VERSION.to_s > '2.4'
      get :index, agile_query_params.merge({:f_status => IssueStatus.where("id != 1").pluck(:id)})
    else
      get :index, agile_query_params.merge({:op => {:status_id => "!"}, :v => {:status_id => ["1"]}})
    end
    assert_response :success
    assert_template :index
    expected_issues = Issue.where(:project_id => [@project_1] + Project.where(:parent_id => @project_1.id).to_a,
      :status_id => IssueStatus.where("id != 1"))
    assert_equal expected_issues.map(&:id).sort, assigns[:issues].map(&:id).sort
  end

  def create_subissue
    @issue1 = Issue.find(1)
    @subissue = Issue.create!(
      :subject         => 'Sub issue',
      :project         => @issue1.project,
      :tracker         => @issue1.tracker,
      :author          => @issue1.author,
      :parent_issue_id => @issue1.id,
      :fixed_version   => Version.last
    )
  end

  def test_get_index_with_filter_on_parent_tracker
    create_subissue
    get :index, agile_query_params.merge({
      :op => {:parent_issue_tracker_id => '='},
      :v => {:parent_issue_tracker_id => [ Tracker.find(1).name ]},
      :f => [:parent_issue_tracker_id],
      :project_id => Project.order(:id).first.id
    })
    assert_response :success
    assert_template :index
    assert_equal [@subissue.id], assigns[:issues].map(&:id)
  end if Redmine::VERSION.to_s > '2.4'

  def test_get_index_with_filter_on_two_parent_id
    create_subissue
    issue2 = Issue.generate!
    child2 =  issue2.generate_child!

    get :index, agile_query_params.merge({
      :op => {:parent_issue_id => '='},
      :v => {:parent_issue_id => [ "#{@issue1.id}, #{issue2.id}" ]},
      :f => [:parent_issue_id],
      :project_id => Project.order(:id).first.id
    })
    assert_response :success
    assert_template :index
    assert_equal [@subissue.id, child2.id].sort, assigns[:issues].map(&:id).sort
  end if Redmine::VERSION.to_s > '2.4'



  def test_get_index_with_filter_on_parent_tracker_inversed
    create_subissue
    get :index, agile_query_params.merge({
      :op => {:parent_issue_tracker_id => '!'},
      :v => {:parent_issue_tracker_id => [ Tracker.find(1).name ]},
      :f => [:parent_issue_tracker_id],
      :project_id => Project.order(:id).first.id
    })
    assert_response :success
    assert_template :index
    assert_not_include @subissue.id, assigns[:issues].map(&:id)
  end if Redmine::VERSION.to_s > '2.4'

  def test_get_index_with_filter_on_has_subissues
    create_subissue
    get :index, agile_query_params.merge({
      :op => {:has_sub_issues => '='},
      :v => {:has_sub_issues => [ 'yes' ]},
      :f => [:has_sub_issues],
      :project_id => Project.order(:id).first.id
    })
    assert_response :success
    assert_template :index
    assert_equal [@issue1.id], assigns[:issues].map(&:id)
  end if Redmine::VERSION.to_s > '2.4'

  def test_get_index_with_filter_and_field_time_in_state
    create_subissue
    columns_group_by = AgileQuery.new.groupable_columns
    columns_group_by.each do |col|
      get :index, agile_query_params.merge({
        :project_id => Project.order(:id).first.id,
        :group_by => col.name.to_s
        })
      assert_response :success, "Error with group by #{col.name}"
      assert_template :index
    end
  end if Redmine::VERSION.to_s > '2.4'

  def test_put_update_status
    status_id = 1
    first_issue_id = 1
    second_issue_id = 3
    first_pos = 1
    second_pos = 2
    positions = { first_issue_id.to_s => { 'position' => first_pos }, second_issue_id.to_s => { 'position' => second_pos } }
    xhr :put, :update, :id => first_issue_id, :issue => { :status_id => status_id }, :positions => positions
    assert_response :success
    assert_equal status_id, Issue.find(first_issue_id).status_id
    assert_equal first_pos, Issue.find(first_issue_id).agile_data.position
    assert_equal second_pos, Issue.find(second_issue_id).agile_data.position
    # check js code for update board header
    assert_match '$("table.issues-board thead").html(', @response.body
  end

  def test_put_update_version
    fixed_version_id = 3
    first_issue_id = 1
    second_issue_id = 3
    first_pos = 1
    second_pos = 2
    positions = { first_issue_id.to_s => { 'position' => first_pos }, second_issue_id.to_s => { 'position' => second_pos } }
    xhr :put, :update, :id => first_issue_id, :issue => { :fixed_version_id => fixed_version_id }, :positions => positions
    assert_response :success
    assert_equal fixed_version_id, Issue.find(first_issue_id).fixed_version_id
    assert_equal first_pos, Issue.find(first_issue_id).agile_data.position
    assert_equal second_pos, Issue.find(second_issue_id).agile_data.position
  end

  def test_put_update_assigned
    assigned_to_id = 3
    issue_id = 1
    xhr :put, :update, :id => issue_id, :issue => {:assigned_to_id => assigned_to_id}
    assert_response :success
    assert_equal assigned_to_id, Issue.find(issue_id).assigned_to_id
  end

  def test_get_index_with_all_fields
    get :index, agile_query_params.merge({:f => AgileQuery.available_columns.map(&:name)})
    assert_response :success
    assert_template :index
  end

  def test_short_card_for_closed_issue
    with_agile_settings "hide_closed_issues_data" => "1" do
      closed_status = IssueStatus.where(:is_closed => true).pluck(:id)
      closed_issues = Issue.where(:status_id => closed_status)
      project = closed_issues.first.project

      # get :index, agile_query_params.merge(:f_status => closed_status)
      if Redmine::VERSION.to_s > '2.4'
        get :index, agile_query_params.merge(:f_status => closed_status)
      else
        get :index, agile_query_params.merge("f"=>[""])
      end

      assert_response :success
      assert_template :index
      assert_select '.closed-issue', project.issues.where(:status_id => IssueStatus.where(:is_closed => true)).count
    end
  end

  def test_get_tooltip_for_issue
    issue = Issue.where(:status_id => IssueStatus.where(:is_closed => true)).first
    get :issue_tooltip, :id => issue.id
    assert_response :success
    assert_template "agile_boards/_issue_tooltip"
    assert_select 'a.issue', 1
    assert_select 'strong', 6
    assert_match issue.status.name, @response.body
  end

  def test_empty_node_for_tooltip
    with_agile_settings "hide_closed_issues_data" => "1" do
      closed_status = IssueStatus.where(:is_closed => true).pluck(:id)
      if Redmine::VERSION.to_s > '2.4'
        get :index, agile_query_params.merge(:f_status => closed_status)
      else
        get :index, agile_query_params.merge("f"=>[""])
      end
      assert_select "span.tip", {:text => ""}
    end
  end

  def test_setting_for_closed_issues
    with_agile_settings "hide_closed_issues_data" => "0" do
      closed_issues = Issue.where(:status_id => IssueStatus.where(:is_closed => true))
      project = closed_issues.first.project
      get :index, agile_query_params.merge("f"=>[""])
      assert_response :success
      assert_template :index
      assert_select '.closed-issue', 0
    end
  end

  def test_index_with_js_format
    with_agile_settings "hide_closed_issues_data" => "1" do
      closed_issues = Issue.where(:status_id => IssueStatus.where(:is_closed => true))
      project = closed_issues.first.project
      xhr :get, :index, agile_query_params.merge("f"=>[""], :format => :js)
      assert_response :success
      assert_match "$('.tooltip').mouseenter(callGetToolTipInfo)", @response.body
    end
  end

  def test_get_index_with_day_in_state_and_parent_group
    get :index, agile_query_params.merge(:c => ["day_in_state"], :group_by => "parent")
    assert_response :success
    assert_template :index
  end

  def test_assinged_to_and_in_state_in_index
    issue1 = Issue.find(1)
    issue2 = Issue.create!(
      :subject         => 'Test assigned_to with day in state',
      :project         => issue1.project,
      :tracker         => issue1.tracker,
      :author          => issue1.author,
      :fixed_version   => Version.last
    )
    get :index, agile_query_params.merge(:c => ["day_in_state"], :group_by => "parent")
    assigned_to_id = 3
    issue_id = issue2.id
    xhr :put, :update, :id => issue_id, :issue => {:assigned_to_id => assigned_to_id}
    assert_response :success
    issue2.reload
    assert_equal assigned_to_id, issue2.assigned_to_id
  end

  def test_index_with_relations_relates
    create_issue_relation
    get :index, agile_query_params.merge(:f_status => IssueStatus.pluck(:id), :op => {:status_id => "*", :relates => "*"}, :f => ["relates"])
    assert_response :success
    assert_template :index
    assert_equal [1, 7, 8], assigns[:issues].map(&:id).sort
  end if Redmine::VERSION.to_s > '2.4'

  def test_index_with_relations_blocked
    create_issue_relation

    get :index, agile_query_params.merge(:f_status => IssueStatus.pluck(:id), :op => {:status_id => "*", :blocked => "*"}, :f => ["blocked"])
    assert_response :success
    assert_template :index
    assert_equal [2, 11], assigns[:issues].map(&:id).sort
  end if Redmine::VERSION.to_s > '2.4'

  def test_list_of_attributes_on_update_status
    params = agile_query_params.merge(:c => ["project", "day_in_state"], :group_by => "parent")
    params.delete(:project_id)
    get :index, params
    assert_response :success
    assert_template :index
    assert_select 'p.project'
    put :update, {:issue => {:status_id => 2}, :id => 1 }
    assert_select 'p.project', {:text => @project_1.to_s}
  end

  def test_day_in_state_when_change_status
    @request.session[:agile_query] = {}
    @request.session[:agile_query][:column_names] = ["project", "day_in_state"]
    issue = Issue.find(1)
    put :update, {:issue => {:status_id => 2}, :id => 1 }
    issue.reload
    assert_response :success
    assert_equal 2, issue.status_id
    assert_select 'p.attributes', /0.hours/
  end if Redmine::VERSION.to_s > '2.4'

  def test_global_query_and_project_board
    query = AgileQuery.create(:name => 'global', :column_names => ["project"], :visibility => 2, :options => {:is_default => true})
    get :index, :project_id => 1
    assert_select 'p.project', {:count => 0, :text => Project.find(2).to_s}
  end if Redmine::VERSION.to_s > '2.4'

  def test_total_estimated_hours_for_status
    [1, 2, 3].each do |id|
      issue = Issue.find(id)
      issue.estimated_hours = 10
      issue.save
    end
    get :index, agile_query_params.merge(:c => ["estimated_hours"])
    assert_response :success
    assert_select 'thead tr th span.hours', {:count => 1, :text => "20.00h"} #status_id == 1
    assert_select 'thead tr th span.hours', {:count => 1, :text => "10.00h"} #status_id == 2
  end if Redmine::VERSION.to_s > '2.4'

  def test_get_index_with_checklist
    # global board
    issue1 = issue_with_checklist

    get :index, agile_query_params.merge(:c => ["checklists"], :project_id => nil)
    assert_response :success
    # check checklist nodes
    assert_select "#checklist_#{issue1.id}"
    issue1.checklists.each do |checklist|
      assert_select "#checklist_item_#{checklist.id}", :text => checklist.subject
    end
  end if RedmineAgile.use_checklist?

  def test_get_index_without_checklist
    issue1 = issue_with_checklist
    get :index, :c => []
    assert_response :success
    # check checklist nodes
    assert_select "#checklist_#{issue1.id}", :count => 0
    issue1.checklists.each do |checklist|
      assert_select "#checklist_item_#{checklist.id}", :count => 0
    end

  end if RedmineAgile.use_checklist?

  def test_get_index_with_project_with_checklist
    issue1 = issue_with_checklist
    get :index, agile_query_params.merge(:c => ["checklists"], :project_id => issue1.project)
    assert_response :success
    # check checklist nodes
    assert_select "#checklist_#{issue1.id}"
    issue1.checklists.each do |checklist|
      assert_select "#checklist_item_#{checklist.id}", :text => checklist.subject
    end
  end if RedmineAgile.use_checklist?

  def test_get_index_with_project_without_checklist
    issue1 = issue_with_checklist
    get :index, agile_query_params.merge(:project_id => issue1.project, :c => [])
    assert_response :success
    # check checklist nodes
    assert_select "#checklist_#{issue1.id}", :count => 0
    issue1.checklists.each do |checklist|
      assert_select "#checklist_item_#{checklist.id}", :count => 0
    end
  end if RedmineAgile.use_checklist?

  def test_get_index_check_quick_edit_without_permission
    role = Role.find(2)
    role.permissions << :veiw_issues
    role.permissions << :view_agile_queries
    role.permissions.delete(:edit_issues)
    role.save
    @request.session[:user_id] = 3

    get :index, :project_id => @project_1
    issues = Issue.where(:project_id => [@project_1],
      :status_id => IssueStatus.where(:is_closed => false))
    assert_response :success
    assert_select ".issue-card", assigns[:issues].count
    assert_select ".issue-card .quick-edit-card a", :count => 0
  end

  def test_last_comment_on_issue_cart
    issue = @project_1.issues.open.first
    text_comment = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus in blandit ex. Donec vitae urna quis tortor tempor mollis."
    comment = Journal.new(:notes => text_comment, :user_id => 1)
    issue.journals << comment
    params = agile_query_params.merge(:c => ["project", "last_comment"], :group_by => "parent")
    get :index, params
    assert_response :success
    assert_select 'span.last-comment', :text => text_comment.truncate(100)
    put :update, {:issue => {:status_id => 2}, :id => issue.id }
    assert_select 'span.last-comment', :text => text_comment.truncate(100)
  end if Redmine::VERSION.to_s > '2.4'

  def test_show_sp_value_on_issue_cart
    with_agile_settings "estimate_units" => "story_points" do
      issues = @project_1.issues.open.first(3)
      issues.each do |issue|
        issue.agile_data.story_points = issue.id * 10
        issue.save
      end
      params = agile_query_params.merge(:c => ['story_points'])
      get :index, params
      IssueStatus.where(:id => @project_1.issues.open.joins(:status).pluck(:status_id).uniq).each do |status|
        sp_sum = @project_1.issues.eager_load(:agile_data).where(:status_id => status.id).sum("#{AgileData.table_name}.story_points")
        assert_select "th[data-column-id='#{status.id}'] span.hours", :text =>"#{sp_sum}sp"
      end
      issues.each do |issue|
        assert_select ".issue-card[data-id='#{issue.id}'] span.fields p.issue-id span.hours", :text =>"(#{issue.story_points}sp)"
      end
      # check story_points in available_columns for query
      assert_select 'input[value="story_points"]'
    end
  end if Redmine::VERSION.to_s > '2.4'

  def test_show_sp_with_estimated_hours_on_issue_cart
    with_agile_settings "estimate_units" => "story_points" do
      issues = @project_1.issues.open.first(3)
      issues.each do |issue|
        issue.agile_data.story_points = issue.id * 10
        issue.estimated_hours = issue.id * 2
        issue.save
      end
      params = agile_query_params.merge(:c => ['story_points', 'estimated_hours'])
      get :index, params
      # in a header show only story_points!
      IssueStatus.where(:id => @project_1.issues.open.joins(:status).pluck(:status_id).uniq).each do |status|
        sp_sum = @project_1.issues.eager_load(:agile_data).where(:status_id => status.id).sum("#{AgileData.table_name}.story_points")
        assert_select "th[data-column-id='#{status.id}'] span.hours", :text =>"#{sp_sum}sp"
      end
      # in a card show and estimated hours and story points
      issues.each do |issue|
        assert_select ".issue-card[data-id='#{issue.id}'] span.fields p.issue-id span.hours",
        :text =>"(#{"%.2fh" % issue.estimated_hours.to_f}/#{issue.story_points}sp)"
      end
    end if Redmine::VERSION.to_s > '2.4'
  end

  def test_quick_add_comment_button
    with_agile_settings 'allow_inline_comments' => 1 do
      get :index, agile_query_params
      assert_response :success
      assert_select '.quick-edit-card img[alt="Edit"]'
    end
  end if Redmine::VERSION.to_s > '2.4'

  def test_quick_add_comment_form
    get :inline_comment, :id => @project_1.issues.open.first
    assert_response :success
    assert_select 'textarea'
    assert_select 'button'
  end if Redmine::VERSION.to_s > '2.4'

  def test_quick_add_comment_update
    issue = @project_1.issues.open.first
    put :update, {:issue => {:notes => 'new comment!!!'}, :id => issue }
    assert_response :success
    assert_select ".last_comment", :text => 'new comment!!!'
  end if Redmine::VERSION.to_s > '2.4'

  
  def test_card_for_new_issue
  with_agile_settings "allow_create_card" => 1 do
  statuses = IssueStatus.all
  get :index, {
  "set_filter"=>"1", :project_id => @project_1, :f_status => statuses.map(&:id) }
  assert_select '.add-issue input.new-card__input', 0
  end
  end if Redmine::VERSION.to_s > '2.4'
  

  def test_on_auto_assign_on_move
    with_agile_settings "auto_assign_on_move" => "1" do
      issue = Issue.find(1)
      assert_equal nil, issue.assigned_to
      put :update, {:issue => {:status_id => 2}, :id => 1 }
      issue.reload
      assert_response :success
      assert_equal 2, issue.status_id
      assert_equal User.current, issue.assigned_to
    end
  end

  def test_off_auto_assign_on_move
    with_agile_settings "auto_assign_on_move" => "0" do
      issue = Issue.find(1)
      assert_equal nil, issue.assigned_to
      put :update, {:issue => {:status_id => 2}, :id => 1 }
      issue.reload
      assert_response :success
      assert_equal 2, issue.status_id
      assert_not_equal User.current, issue.assigned_to
    end
  end

  def test_off_auto_assign_on_move_by_sorting
    with_agile_settings "auto_assign_on_move" => "1" do
      issue = Issue.find(1)
      assert_equal nil, issue.assigned_to
      put :update, {:issue => {:status_id => issue.status_id}, :id => 1 }
      issue.reload
      assert_response :success
      assert_not_equal User.current, issue.assigned_to
    end
  end

  private

  def agile_query_params
    {:set_filter => "1", :f => ["status_id", ""], :op => {:status_id => "o"}, :c => ["tracker", "assigned_to"],  :project_id => "ecookbook"}
  end

  def create_issue_relation
    IssueRelation.delete_all
    IssueRelation.create!(:relation_type => "relates", :issue_from => Issue.find(1), :issue_to => Issue.find(7))
    IssueRelation.create!(:relation_type => "relates", :issue_from => Issue.find(8), :issue_to => Issue.find(1))
    IssueRelation.create!(:relation_type => "blocks", :issue_from => Issue.find(1), :issue_to => Issue.find(11))
    IssueRelation.create!(:relation_type => "blocks", :issue_from => Issue.find(12), :issue_to => Issue.find(2))
  end

  def issue_with_checklist
    issue1 = Issue.find(1)
    chk1 = issue1.checklists.create(:subject => 'TEST1', :position => 1)
    chk2 = issue1.checklists.create(:subject => 'TEST2', :position => 2)
    issue1
  end if RedmineAgile.use_checklist?

end
