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

require 'SVG/Graph/TimeSeries'
require 'SVG/Graph/Line'
require 'SVG/Graph/Plot'
require 'SVG/Graph/Bar'

module RedmineAgile
  class AgileChart
    include Redmine::I18n
    include Redmine::Utils::DateCalculation

    def initialize(data_scope, options={})
      @data_scope = data_scope
      @data_from ||= options[:data_from]
      @data_to ||= options[:data_to]
      @period_count, @scale_division = chart_periods
      @step_x_labels = @period_count > 18 ? @period_count / 12 + 1 : 1
      @fields = chart_fields_by_period
      @weekend_periods = weekend_periods
    end

    def render
    end

    def self.render(data_scope, options={})
      self.new(data_scope, options).render
    end

  protected

    def current_date_period
      @current_date_period ||= (@date_to < Date.today ? @period_count - 1 : ( @period_count - (@date_to - Date.today).to_i / @scale_division - 1) + 1 ).round
    end

    def due_date_period
      due_date = (@due_date && @due_date > @date_from) ? @due_date : @date_from
      @due_date_period ||= (@due_date ? @period_count - (@date_to - due_date).to_i / @scale_division - 1: @period_count - 1) + 1
    end

    def date_effort(issues, effort_date)
      cumulative_left = 0
      total_left = 0
      total_done = 0
      issues.each do |issue|
        done_ratio_details = issue.journals.map(&:details).flatten.select {|detail| 'done_ratio' == detail.prop_key }
        details_today_or_earlier = done_ratio_details.select {|a| a.journal.created_on.localtime.to_date <= effort_date }

        last_done_ratio_change = details_today_or_earlier.sort_by {|a| a.journal.created_on }.last
        ratio = if issue.closed? && issue.closed_on.localtime.to_date <= effort_date
          100
        elsif last_done_ratio_change
          last_done_ratio_change.value
        elsif (done_ratio_details.size > 0) || (issue.closed? && issue.closed_on > effort_date)
          0
        else
          issue.done_ratio.to_i
        end

        if RedmineAgile.use_story_points?
          cumulative_left += (issue.story_points.to_f * ratio.to_f / 100.0)
          total_left += (issue.story_points.to_f * (100 - ratio.to_f) / 100.0)
          total_done += (issue.story_points.to_f * ratio.to_f / 100.0)
        else
          cumulative_left += (issue.estimated_hours.to_f * ratio.to_f / 100.0)
          total_left += (issue.estimated_hours.to_f * (100 - ratio.to_f) / 100.0)
          total_done += (issue.estimated_hours.to_f * ratio.to_f / 100.0)
        end

      end
      [total_left, cumulative_left, total_done]
    end

  private

    def scope_by_created_date
      @data_scope.
        where("#{Issue.table_name}.created_on >= ?", @date_from).
        where("#{Issue.table_name}.created_on < ?", @date_to.to_date + 1).
        where("#{Issue.table_name}.created_on IS NOT NULL").
        group("#{Issue.table_name}.created_on").
        count
    end

    def scope_by_closed_date
      @data_scope.
        open(false).
        where("#{Issue.table_name}.closed_on >= ?", @date_from).
        where("#{Issue.table_name}.closed_on < ?", @date_to.to_date + 1).
        where("#{Issue.table_name}.closed_on IS NOT NULL").
        group("#{Issue.table_name}.closed_on").
        count
    end

    def data_points(data)
      data.inject([]) { |result, var|  result << [result.size, var]}.flatten
    end

    def chart_periods
      raise Exception "Dates can't be blank" if [@date_to, @date_from].any?(&:blank?)
      period_count = (@date_to.to_date + 1 - @date_from.to_date).to_i
      scale_division = period_count > 31 ? period_count / 31.0 : 1

      [(period_count / scale_division).round, scale_division]
    end

    def issues_count_by_period(issues_scope)
      data = [0] * @period_count
      issues_scope.each do |c|
        next if c.first.localtime.to_date > @date_to.to_date
        period_num = ((@date_to.to_date - c.first.localtime.to_date).to_i / @scale_division).to_i
        data[period_num] += c.last unless data[period_num].blank?
      end
      data.reverse
    end

    def issues_avg_count_by_period(issues_scope)
      count_by_date = {}
      issues_scope.each{|x, y| count_by_date[x.localtime.to_date] = count_by_date[x.localtime.to_date].to_i + y}
      data = [0] * @period_count
      count_by_date.each do |x, y|
        next if x.to_date > @date_to.to_date
        period_num = ((@date_to.to_date - x.to_date).to_i / @scale_division).to_i
        if data[period_num]
          data[period_num] = y unless data[period_num].to_i > 0
          data[period_num] = (data[period_num] + y) / 2.0
        end
      end
      data.reverse
    end

    def chart_fields_by_period
      chart_dates_by_period.map do |d|
        if @scale_division >= 365
          d.year
        elsif @scale_division >= 13
          month_abbr_name(d.at_beginning_of_week.to_time.month) + " " + d.at_beginning_of_week.to_time.year.to_s
        elsif @scale_division >= 7
          d.at_beginning_of_week.to_time.day.to_s + " " + month_name(d.at_beginning_of_week.to_time.month)
        else
          d.to_time.day.to_s + " " + month_name(d.to_time.month)
        end
      end
    end

    def weekend_periods
      periods = []
      @period_count.times do |m|
        period_date = ((@date_to.to_date - 1 - m * @scale_division) + 1)
        periods << @period_count - m - 1 if non_working_week_days.include?(period_date.cwday)
      end
      periods.compact
    end

    def chart_data_pairs(chart_data)
      chart_data.inject([]) { |accum, value| accum << value }
      data_pairs = []
      for i in 0..chart_data.count - 1
        data_pairs << [chart_dates_by_period[i], chart_data[i]]
      end
      data_pairs
    end

    def chart_dates_by_period
      @chart_dates_by_period ||= @period_count.times.inject([]) do |accum, m|
        period_date = ((@date_to.to_date - 1 - m * @scale_division) + 1)
        accum << if m == 0 || m == @period_count - 1
          period_date.to_date
        elsif @scale_division >= 13
          period_date.at_beginning_of_week.to_date
        elsif @scale_division >= 7
          period_date.at_beginning_of_week.to_date
        else
          period_date.to_date
        end
      end.reverse
    end

    def month_abbr_name(month)
      l('date.abbr_month_names')[month]
    end

  end
end
