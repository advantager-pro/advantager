# Redmine - project management software
# Copyright (C) 2006-2015  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class SearchController < ApplicationController
  before_filter :find_optional_project

  def index
    @question = params[:q] || ""
    @question.strip!
    @all_words = params[:all_words] ? params[:all_words].present? : true
    @titles_only = params[:titles_only] ? params[:titles_only].present? : false
    @search_attachments = params[:attachments].presence || '0'
    @open_issues = params[:open_issues] ? params[:open_issues].present? : false

    # quick jump to an issue
    if (m = @question.match(/^#?(\d+)$/)) && (issue = Issue.visible.find_by_id(m[1].to_i))
      redirect_to issue_path(issue)
      return
    end

    projects_to_search =
      case params[:scope]
      when 'all'
        nil
      when 'my_projects'
        User.current.projects
      when 'subprojects'
        @project ? (@project.self_and_descendants.active.to_a) : nil
      else
        @project
      end

    @object_types = Redmine::Search.available_search_types.dup
    if projects_to_search.is_a? Project
      # don't search projects
      @object_types.delete('projects')
      # only show what the user is allowed to view
      @object_types = @object_types.select {|o| User.current.allowed_to?("view_#{o}".to_sym, projects_to_search)}
    end

    @scope = @object_types.select {|t| params[t]}
    @scope = @object_types if @scope.empty?

    fetcher = Redmine::Search::Fetcher.new(
      @question, User.current, @scope, projects_to_search,
      :all_words => @all_words, :titles_only => @titles_only, :attachments => @search_attachments, :open_issues => @open_issues,
      :cache => params[:page].present?
    )

    if fetcher.tokens.present?
      @result_count = fetcher.result_count
      @result_count_by_type = fetcher.result_count_by_type
      @tokens = fetcher.tokens

      per_page = Setting.search_results_per_page.to_i
      per_page = 10 if per_page == 0
      @result_pages = Paginator.new @result_count, per_page, params['page']
      @results = fetcher.results(@result_pages.offset, @result_pages.per_page)
    else
      @question = ""
    end
    render :layout => false if request.xhr?
  end

private
  def find_optional_project
    return true unless params[:id]
    @project = Project.find(params[:id])
    check_project_privacy
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
