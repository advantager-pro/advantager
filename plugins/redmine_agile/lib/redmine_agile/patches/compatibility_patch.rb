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

class AgileQuery < Query
  unloadable

  VISIBILITY_PRIVATE = 0
  VISIBILITY_ROLES   = 1
  VISIBILITY_PUBLIC  = 2

  attr_reader :truncated

  self.queried_class = Issue

  self.available_columns = [
    QueryColumn.new(:id, :sortable => "#{Issue.table_name}.id", :default_order => 'desc', :caption => :label_agile_issue_id),
    QueryColumn.new(:project, :groupable => "#{Issue.table_name}.project_id"),
    QueryColumn.new(:tracker, :sortable => "#{Tracker.table_name}.position", :groupable => true),
    QueryColumn.new(:estimated_hours, :sortable => "#{Issue.table_name}.estimated_hours"),
    QueryColumn.new(:done_ratio, :sortable => "#{Issue.table_name}.done_ratio"),
    QueryColumn.new(:parent, :groupable => "#{Issue.table_name}.parent_id", :caption => :field_parent_issue),
    QueryColumn.new(:assigned_to, :sortable => lambda {User.fields_for_order_statement}, :groupable => "#{Issue.table_name}.assigned_to_id")
  ]

  scope :visible, lambda {|*args|
    user = args.shift || User.current
    base = Project.allowed_to_condition(user, :view_issues, *args)
    user_id = user.logged? ? user.id : 0

    eager_load(:project).where("(#{table_name}.project_id IS NULL OR (#{base})) AND (#{table_name}.is_public = ? OR #{table_name}.user_id = ?)", true, user_id)
  }

  def initialize(attributes=nil, *args)
    attributes.delete(:color_base) if attributes
    super attributes
    self.filters ||= { 'status_id' => {:operator => "o", :values => [""]} }
    @truncated = false
  end

  def card_columns
    self.inline_columns.select{|c| !%w(tracker thumbnails description assigned_to done_ratio spent_hours estimated_hours project id day_in_state last_comment story_points).include?(c.name.to_s)}
  end

  def visible?(user=User.current)
    (project.nil? || user.allowed_to?(:view_issues, project)) && (self.is_public? || self.user_id == user.id)
  end

  def is_private?
    visibility == VISIBILITY_PRIVATE
  end

  def is_public?
    !is_private?
  end

  def self.default_query(project=nil)
    false
  end

  def visibility=(value)
    self.is_public = value == VISIBILITY_PUBLIC
  end

  def visibility
    self.is_public ? VISIBILITY_PUBLIC : VISIBILITY_PRIVATE
  end

  def build_from_params(params)
    if params[:fields] || params[:f]
      self.filters = {}
      add_filters(params[:fields] || params[:f], params[:operators] || params[:op], params[:values] || params[:v])
    else
      available_filters.keys.each do |field|
        add_short_filter(field, params[field]) if params[field]
      end
    end
    self.group_by = params[:group_by] || (params[:query] && params[:query][:group_by])
    self.column_names = params[:c] || (params[:query] && params[:query][:column_names])
    self
  end

  # Builds a new query from the given params and attributes
  def self.build_from_params(params, attributes={})
    new(attributes).build_from_params(params)
  end

  def initialize_available_filters
    principals = []
    subprojects = []
    versions = []
    categories = []
    issue_custom_fields = []

    if project
      principals += project.principals.sort
      unless project.leaf?
        subprojects = project.descendants.visible.all
        principals += Principal.member_of(subprojects)
      end
      versions = project.shared_versions.all
      categories = project.issue_categories.all
      issue_custom_fields = project.all_issue_custom_fields
    else
      if all_projects.any?
        principals += Principal.member_of(all_projects)
      end
      versions = Version.visible.where(:sharing => 'system').all
      issue_custom_fields = IssueCustomField.where(:is_for_all => true)
    end
    principals.uniq!
    principals.sort!
    users = principals.select {|p| p.is_a?(User)}

    add_available_filter "status_id",
      :type => :list_status, :values => IssueStatus.sorted.collect{|s| [s.name, s.id.to_s] }

    if project.nil?
      project_values = []
      if User.current.logged? && User.current.memberships.any?
        project_values << ["<< #{l(:label_my_projects).downcase} >>", "mine"]
      end
      project_values += all_projects_values
      add_available_filter("project_id",
        :type => :list, :values => project_values
      ) unless project_values.empty?
    end

    add_available_filter "tracker_id",
      :type => :list, :values => trackers.collect{|s| [s.name, s.id.to_s] }
    add_available_filter "priority_id",
      :type => :list, :values => IssuePriority.all.collect{|s| [s.name, s.id.to_s] }

    author_values = []
    author_values << ["<< #{l(:label_me)} >>", "me"] if User.current.logged?
    author_values += users.collect{|s| [s.name, s.id.to_s] }
    add_available_filter("author_id",
      :type => :list, :values => author_values
    ) unless author_values.empty?

    assigned_to_values = []
    assigned_to_values << ["<< #{l(:label_me)} >>", "me"] if User.current.logged?
    assigned_to_values += (Setting.issue_group_assignment? ?
                              principals : users).collect{|s| [s.name, s.id.to_s] }
    add_available_filter("assigned_to_id",
      :type => :list_optional, :values => assigned_to_values
    ) unless assigned_to_values.empty?

    if versions.any?
      add_available_filter "fixed_version_id",
        :type => :list_optional,
        :values => versions.sort.collect{|s| ["#{s.project.name} - #{s.name}", s.id.to_s] }
    end

    if categories.any?
      add_available_filter "category_id",
        :type => :list_optional,
        :values => categories.collect{|s| [s.name, s.id.to_s] }
    end

    add_available_filter "subject", :type => :text
    add_available_filter "created_on", :type => :date_past
    add_available_filter "updated_on", :type => :date_past
    add_available_filter "closed_on", :type => :date_past
    add_available_filter "start_date", :type => :date
    add_available_filter "due_date", :type => :date
    add_available_filter "estimated_hours", :type => :float
    add_available_filter "done_ratio", :type => :integer

    if subprojects.any?
      add_available_filter "subproject_id",
        :type => :list_subprojects,
        :values => subprojects.collect{|s| [s.name, s.id.to_s] }
    end

    add_custom_fields_filters(issue_custom_fields)

    add_associations_custom_fields_filters :project, :author, :assigned_to, :fixed_version

    Tracker.disabled_core_fields(trackers).each {|field|
      delete_available_filter field
    }
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns += (project ?
                            project.all_issue_custom_fields :
                            IssueCustomField.all
                           ).collect {|cf| QueryCustomFieldColumn.new(cf) }

    if User.current.allowed_to?(:view_time_entries, project, :global => true)
      index = nil
      @available_columns.each_with_index {|column, i| index = i if column.name == :estimated_hours}
      index = (index ? index + 1 : -1)
      # insert the column after estimated_hours or at the end
      @available_columns.insert index, QueryColumn.new(:spent_hours,
        :sortable => "COALESCE((SELECT SUM(hours) FROM #{TimeEntry.table_name} WHERE #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id), 0)",
        :default_order => 'desc',
        :caption => :label_spent_time
      )
    end

    disabled_fields = Tracker.disabled_core_fields(trackers).map {|field| field.sub(/_id$/, '')}
    @available_columns.reject! {|column|
      disabled_fields.include?(column.name.to_s)
    }

    @available_columns.reject! {|column| column.name == :done_ratio} unless Issue.use_field_for_done_ratio?

    @available_columns
  end

  def editable_by?(user)
    return false unless user
    # Admin can edit them all and regular users can edit their private queries
    return true if user.admin? || (is_private? && self.user_id == user.id)
    # Members can not edit public queries that are for all project (only admin is allowed to)
    is_public? && !@is_for_all && user.allowed_to?(:manage_public_agile_queries, project)
  end

  def default_columns_names
    @default_columns_names = RedmineAgile.default_columns.map(&:to_sym)
  end

  def has_column_name?(name)
    columns.detect{|c| c.name == name}
  end

  def groupable_columns
    available_columns.select {|c| c.groupable && !c.is_a?(QueryCustomFieldColumn)}
  end

  def issues(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)

    scope = issue_scope.
      joins(:status, :project).
      includes((options[:include] || []).uniq).
      where(options[:conditions]).
      order(order_option).
      joins(joins_for_order_statement(order_option.join(','))).
      limit(options[:limit]).
      offset(options[:offset])

    scope = scope.preload(:custom_values)
    if has_column?(:author)
      scope = scope.preload(:author)
    end

    # if has_column?(:spent_hours)
    #   Issue.load_visible_spent_hours(issues)
    # end

    scope
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  # for compatibility with upper versions
  def issue_last_comment(issue_id, options = {})
    nil
  end

  def journals_for_state
    nil
  end

  def board_statuses
    status_filter_operator = filters.fetch("status_id", {}).fetch(:operator, nil)
    status_filter_values = filters.fetch("status_id", {}).fetch(:values, [])
    statuses = IssueStatus.where(:id => Tracker.includes(:issues => [:status, :project, :fixed_version]).where(statement).map(&:issue_statuses).flatten.uniq.map(&:id))
    result_statuses = case status_filter_operator
    when "o"
      statuses.where(:is_closed => false).sorted
    when "c"
      statuses.where(:is_closed => true).sorted
    when "="
      statuses.where(:id => status_filter_values).sorted
    when "!"
      statuses.where("#{IssueStatus.table_name}.id NOT IN (" + status_filter_values.map{|val| "'#{connection.quote_string(val)}'"}.join(",") + ")").sorted
    else
      statuses.sorted
    end
    result_statuses.map do |s|
      s.instance_variable_set "@issue_count", self.issue_count_by_status[s.id]
      s
    end
  end

  def issue_count_by_status
    @issue_count_by_status ||= issue_scope.group("#{Issue.table_name}.status_id").count
  end

  def issue_board(options={})
    @truncated = RedmineAgile.board_items_limit <= issue_scope.count
    all_issues = self.issues.limit(RedmineAgile.board_items_limit).sorted_by_rank
    all_issues.group_by{|i| [i.status_id]}
      end

private
  def issue_scope
    Issue.visible.
      includes(:status,
               :project,
               :assigned_to,
               :tracker,
               :priority,
               :category,
               :fixed_version).
      where(statement)
  end

end if Redmine::VERSION.to_s < '2.4'
