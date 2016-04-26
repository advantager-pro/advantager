# encoding: utf-8
#
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

require File.expand_path('../../test_helper', __FILE__)

# Re-raise errors caught by the controller.
# class HelpdeskMailerController; def rescue_action(e) raise e end; end

class IssuesControllerTest < ActionController::TestCase
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


  RedmineChecklists::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_checklists).directory + '/test/fixtures/',
                                         [:checklists])


  def setup
    @request.session[:user_id] = 1
  end

  def test_get_show_issue
    issue = Issue.find(1)
    assert_not_nil issue.checklists.first
    get :show, :id => 1
    assert_response :success
    assert_select "ul#checklist_items li#checklist_item_1", /First todo/
    assert_select "ul#checklist_items li#checklist_item_1 input[checked=?]", "checked", {:count => 0}
    assert_select "ul#checklist_items li#checklist_item_2 input[checked=?]", "checked"
  end

  def test_get_edit_issue
    get :edit, :id => 1
    assert_response :success
  end

  def test_get_copy_issue
    get :new, :project_id => 1, :copy_from => 1
    assert_response :success
    assert_select "span#checklist_form_items span.checklist-subject", {:count => 3}
    assert_select "span#checklist_form_items span.checklist-edit input[value=?]", "First todo"
  end

  def test_put_update_form
    parameters = {:tracker_id => 2,
                  :checklists_attributes => {
                    "0" => {"is_done"=>"0", "subject"=>"First"},
                    "1" => {"is_done"=>"0", "subject"=>"Second"}}}

    @request.session[:user_id] = 1
    issue = Issue.find(1)
    if Redmine::VERSION.to_s > '2.3' && Redmine::VERSION.to_s < '3.0'
      xhr :put, :update_form,
                :issue => parameters,
                :project_id => issue.project
    else
      xhr :put, :new,
                :issue => parameters,
                :project_id => issue.project
    end
    assert_response :success
    assert_equal 'text/javascript', response.content_type

    if Redmine::VERSION.to_s < '3.0'
      assert_template 'update_form'
    else
      assert_template 'new'
    end

    issue = assigns(:issue)
    assert_kind_of Issue, issue
    assert_match 'First', issue.checklists.map(&:subject).join
  end

  def test_update_sends_email
    Setting[:plugin_redmine_checklists] = { :save_log => 1, :issue_done_ratio => 0 }
    parameters = {:checklists_attributes => {
                    "0" => {"is_done"=>"0", "subject"=>"Third"},
                    "1" => {"is_done"=>"1", "subject"=>"Fourth"},
                    "2" => {"id" => 2, "_destroy"=>"1", "subject"=>"Second todo"}
                    } }

    @request.session[:user_id] = 1
    issue = Issue.find(1)
    User.find(2).create_email_address(:address => 'test@example.com') if Redmine::VERSION.to_s >= '3.0'
    xhr :put, :update,
              :issue => parameters,
              :project_id => issue.project,
              :id => issue.to_param
    assert ActionMailer::Base.deliveries.last
    email = ActionMailer::Base.deliveries.last
    assert_include 'Checklist item [ ] Third added', email.text_part.body.to_s
    assert_include 'Checklist item [x] Fourth added', email.text_part.body.to_s
    assert_include 'Checklist item deleted (Second todo)', email.text_part.body.to_s
  end

  def test_added_attachment_shows_in_log_once
    Setting[:plugin_redmine_checklists] = { :save_log => 1, :issue_done_ratio => 0 }
    set_tmp_attachments_directory
    parameters = { :tracker_id => 2,
                   :checklists_attributes => {
                     '0' => { 'is_done' => '0', 'subject' => 'First' },
                     '1' => { 'is_done' => '0', 'subject' => 'Second' } } }
    @request.session[:user_id] = 1
    issue = Issue.find(1)
    post :update,
          :issue => parameters,
          :attachments => { '1' => { 'file' => uploaded_test_file('testfile.txt', 'text/plain'), 'description' => 'test file' } },
          :project_id => issue.project,
          :id => issue.to_param
    assert_response :redirect
    assert_equal 1, Journal.last.details.where(:property => 'attachment').count
  end

  def test_update_with_delete_write_to_journal
    Setting[:plugin_redmine_checklists] = { :save_log => 1, :issue_done_ratio => 0 }
    @request.session[:user_id] = 1
    issue = Issue.find(1)
    User.find(2).create_email_address(:address => 'test@example.com') if Redmine::VERSION.to_s >= '3.0'
    #Create new checklist
    xhr :put, :update,
          :issue => { :notes => 'fix me',
                      :checklists_attributes => {"0" => {"is_done"=>"0", "subject"=>"Five"}} },
          :project_id => issue.project,
          :id => issue.to_param
    assert_response :redirect
    issue.reload
    #Delete new checklist
    xhr :put, :update,
              :issue => { :checklists_attributes => {"0" => {"id" => issue.checklists.max.id, "_destroy"=>"1", "subject"=>"First todo"} } },
              :project_id => issue.project,
              :id => issue.to_param
    assert_response :redirect

    get :show, :id => issue.id
    assert_response :success
    assert_select "#change-#{issue.journals.last.id} .details li", "Checklist item deleted (Five)"
  end

  def test_history_dont_show_old_format_checklists
    Setting[:plugin_redmine_checklists] = { :save_log => 1, :issue_done_ratio => 0 }
    @request.session[:user_id] = 1
    issue = Issue.find(1)
    issue.journals.create!(:user_id => 1)
    issue.journals.last.details.create!(:property =>  'attr',
                                        :prop_key =>  'checklist',
                                        :old_value => '[ ] TEST',
                                        :value =>     '[x] TEST')

    post :show, :id => issue.id
    assert_response :success
    last_journal = issue.journals.last
    assert_equal last_journal.details.size, 1
    assert_equal last_journal.details.first.prop_key, 'checklist'
    assert_select "#change-#{last_journal.id} .details li", 'Checklist item changed from [ ] TEST to [x] TEST'
  end

end
