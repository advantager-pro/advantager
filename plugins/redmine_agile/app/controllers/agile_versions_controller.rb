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

class AgileVersionsController < ApplicationController
  unloadable

  menu_item :agile
  
  before_filter :find_project_by_project_id, :only => [:index, :autocomplete, :load]
  before_filter :find_version, :only => [:load]
  before_filter :authorize, :except => [:autocomplete, :load]
  before_filter :find_no_version_issues, :only => [:index, :autocomplete]

  include QueriesHelper
  helper :queries
  include RedmineAgile::AgileHelper

  def index
    retrieve_versions_query
      @backlog_version = @query.backlog_version
      @backlog_version_issues =  @query.backlog_version_issues

      @current_version = @query.current_version
      @current_version_issues = @query.current_version_issues
    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def autocomplete
    render :layout => false
  end

  def load
    retrieve_versions_query
    @version_issues = @query.version_issues(@version)
    @version_type = params[:version_type]
    @other_version_type = @version_type == "backlog" ? "current" : "backlog"
    @other_version_id = params[:other_version_id]
    respond_to do |format|
      format.js
    end
  end

  private

  def find_version
    @version = Version.visible.find(params[:version_id])
    @project ||= @version.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_no_version_issues
    retrieve_versions_query
      scope = @query.no_version_issues(params)
      @issue_count = scope.count
      @issue_pages = Redmine::Pagination::Paginator.new @issue_count, 20, params['page']
      @version_issues = scope.offset(@issue_pages.offset).limit(@issue_pages.per_page).all
  end

end
