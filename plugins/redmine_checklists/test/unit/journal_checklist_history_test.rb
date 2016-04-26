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

class JournalChecklistHistoryTest < ActiveSupport::TestCase
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
    RedmineChecklists::TestCase.prepare
    Setting.default_language = 'en'
    @project_1 = Project.find(1)
    @issue_1 = Issue.create(:project => @project_1, :tracker_id => 1, :author_id => 1,
                            :status_id => 1, :priority => IssuePriority.first,
                            :subject => 'TestIssue')

    @checklist_1 = Checklist.create(:subject => 'TEST1', :position => 1, :issue => @issue_1)
    @checklist_2 = Checklist.create(:subject => 'TEST2', :position => 2, :issue => @issue_1, :is_done => true)
    @checklist_3 = Checklist.create(:subject => 'TEST3', :position => 3, :issue => @issue_1, :is_done => true)
  end

  test 'JournalChecklistHistory exists' do
    assert JournalChecklistHistory
  end

  test 'JournalChecklistHistory can discover that checklist has been added' do
    checklist_set_1 = [@checklist_1, @checklist_2]
    checklist_set_2 = [@checklist_1, @checklist_2, @checklist_3]
    diff = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).diff

    assert(diff[:added])
    assert_equal(@checklist_3.id, diff[:added].map(&:to_h)[0]['id'])
  end

  test 'JournalChecklistHistory can discover that checklist has been removed' do
    checklist_set_1 = [@checklist_1, @checklist_2]
    checklist_set_2 = [@checklist_1, @checklist_2, @checklist_3]

    diff = JournalChecklistHistory.new(checklist_set_2, checklist_set_1).diff

    assert(diff[:removed])
    assert_equal(@checklist_3.id, diff[:removed].map(&:to_h)[0]['id'])
  end

  test 'JournalChecklistHistory can discover that checklist has been renamed' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_2_dup = @checklist_2.dup
    @checklist_2_dup.subject = 'TEST2_CHANGED'
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_2_dup.id = @checklist_2.id

    checklist_set_2 = [@checklist_1, @checklist_2_dup]

    diff = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).diff

    assert(diff[:renamed])
    assert_equal({ @checklist_2.subject => @checklist_2_dup.subject }, diff[:renamed])
  end

  test 'is able to work with JSON representations' do
    checklist_set_1 = [@checklist_1, @checklist_2].to_json
    checklist_set_2 = [@checklist_1, @checklist_2, @checklist_3].to_json

    diff = JournalChecklistHistory.new(checklist_set_2, checklist_set_1).diff

    assert(diff[:removed])
    # In fact diff can contain OpenStruct instances instead of Checklists
    # But they should have same attributes
    assert_equal(@checklist_3.id, diff[:removed].map(&:to_h)[0]['id'])
    assert_equal(@checklist_3.subject, diff[:removed].map(&:to_h)[0]['subject'])
    assert_equal(@checklist_3.is_done, diff[:removed].map(&:to_h)[0]['is_done'])
  end

  test 'JournalChecklistHistory able to create JournalDetail' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_2_dup = @checklist_2.dup
    @checklist_2_dup.subject = 'TEST2_CHANGED'
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_2_dup.id = @checklist_2.id
    checklist_set_2 = [@checklist_2_dup, @checklist_3]
    details = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).journal_details(:journal => @issue_1.current_journal)
    assert_equal details.prop_key, 'checklist'
    assert_equal JSON.parse(details.old_value)[1]['subject'], 'TEST2'
    assert_equal JSON.parse(details.value)[0]['subject'], 'TEST2_CHANGED'
  end

  test 'can define that previous Journal contains only checklist changes' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_2_dup = @checklist_2.dup
    @checklist_2_dup.subject = 'TEST2_CHANGED'
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_2_dup.id = @checklist_2.id
    checklist_set_2 = [@checklist_2_dup, @checklist_3]
    @issue_1.init_journal(User.find(1))
    @old_journal = @issue_1.current_journal
    @issue_1.current_journal.save!
    JournalChecklistHistory.new(checklist_set_1, checklist_set_2).journal_details(:journal => @issue_1.current_journal).save!
    assert_equal(1, @issue_1.journals.size)

    @issue_1 = Issue.find(@issue_1.id)
    @issue_1.init_journal(User.find(1))
    @issue_1.current_journal.save!
    journal_detail = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).journal_details(:journal => @issue_1.current_journal)
    assert(JournalChecklistHistory.can_fixup?(journal_detail))

    JournalDetail.new({
      :property  => 'attr',
      :prop_key  => 'color',
      :old_value => 'blue',
      :value     => 'red',
      :journal   => @old_journal
    }).save!

    assert(!JournalChecklistHistory.can_fixup?(journal_detail))
  end

  test 'is able to fixup JournalDetail if previous Journal contains only checklist changes' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_2_dup = @checklist_2.dup
    @checklist_2_dup.subject = 'TEST2_CHANGED'
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_2_dup.id = @checklist_2.id
    checklist_set_2 = [@checklist_2_dup, @checklist_3]
    @issue_1.init_journal(User.find(1))
    @old_journal = @issue_1.current_journal
    @issue_1.current_journal.save!
    JournalChecklistHistory.new(checklist_set_1, checklist_set_2).journal_details(:journal => @issue_1.current_journal).save!
    assert_equal(1, @issue_1.journals.size)

    @issue_1 = Issue.find(@issue_1.id)
    @issue_1.init_journal(User.find(1))
    @issue_1.current_journal.save!
    checklist_set_2 = [@checklist_1, @checklist_3]
    journal_detail = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).journal_details(:journal => @issue_1.current_journal)
    JournalChecklistHistory.fixup(journal_detail)
    diff = JournalChecklistHistory.new(JournalDetail.last.old_value, JournalDetail.last.value).diff

    assert_equal(@checklist_3.id, diff[:added].map(&:to_h)[0]['id'])
    assert_equal(@checklist_2.id, diff[:removed].map(&:to_h)[0]['id'])
    assert_equal(0, diff[:renamed].size)
  end

  test 'JournalChecklistHistory detects is_done change to undone' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_2_dup = @checklist_2.dup
    @checklist_2_dup.is_done = false
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_2_dup.id = @checklist_2.id
    checklist_set_2 = [@checklist_1, @checklist_2_dup]
    diff = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).diff

    assert(diff[:undone])
    assert_equal(@checklist_2_dup.id, diff[:undone].map(&:to_h)[0]['id'])
  end

  test 'JournalChecklistHistory detects is_done change to done' do
    checklist_set_1 = [@checklist_1, @checklist_2]

    @checklist_1_dup = @checklist_1.dup
    @checklist_1_dup.is_done = true
    # dup is redefined in ActiveRecord so it nullifies id in return value
    # But we are imitating situation when user has modified same instance
    @checklist_1_dup.id = @checklist_1.id
    checklist_set_2 = [@checklist_1_dup, @checklist_2]
    diff = JournalChecklistHistory.new(checklist_set_1, checklist_set_2).diff

    assert(diff[:done])
    assert_equal(@checklist_1_dup.id, diff[:done].map(&:to_h)[0]['id'])
  end

end
