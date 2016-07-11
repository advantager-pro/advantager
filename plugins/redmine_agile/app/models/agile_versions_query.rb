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

class AgileVersionsQuery
  attr_accessor :project

  def backlog_version
    @backlog_version = project.shared_versions.open.where("LOWER(#{Version.table_name}.name) LIKE LOWER(?)", "backlog").first ||
        project.shared_versions.open.where(:effective_date => nil).first ||
        project.shared_versions.open.order("effective_date ASC").first
  end

  def backlog_version_issues
    return [] if backlog_version.blank?
    backlog_version.fixed_issues.open.visible.sorted_by_rank
      end

  def current_version
    @current_version = Version.open.
        where(:project_id => project).
        where("#{Version.table_name}.id <> ?", self.backlog_version).
        order("effective_date DESC").first
  end

  def current_version_issues
    return [] if current_version.blank?
    current_version.fixed_issues.open.visible.sorted_by_rank
      end

  def no_version_issues(params={})
    q = (params[:q] || params[:term]).to_s.strip
    scope = Issue.open.visible
        if project
      project_ids = [project.id]
      project_ids += project.descendants.collect(&:id) if Setting.display_subprojects_issues?
      scope = scope.where(:project_id => project_ids)
    end
    scope = scope.where(:fixed_version_id => nil).sorted_by_rank
        if q.present?
      if q.match(/^#?(\d+)\z/)
        scope = scope.where("(#{Issue.table_name}.id = ?) OR (LOWER(#{Issue.table_name}.subject) LIKE LOWER(?))", $1.to_i,"%#{q}%")
      else
        scope = scope.where("LOWER(#{Issue.table_name}.subject) LIKE LOWER(?)", "%#{q}%")
      end
    end
    scope
  end

  def version_issues(version)
    version.fixed_issues.open.visible.sorted_by_rank
      end
end
