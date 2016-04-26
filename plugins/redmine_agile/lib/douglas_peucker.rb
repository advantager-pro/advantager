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

class DouglasPeucker

  def initialize(points, options={})
    @points = points
    @threshold = options[:threshold] || 10e-8
  end

  def points
    calculate_points(@points)
  end

  def self.reduce(points, options={})
    self.new(points, options).points
  end

  def self.reduce_time_series(time_series, options={})
    points = time_series.map{|x, y| [x.to_time.to_i, y]}
    self.new(points, options).points.map{|x, y| [Time.at(x), y]}
  end

  def self.reduce_date_series(time_series, options={})
    points = time_series.map{|x, y| [x.to_time.to_i, y]}
    self.new(points, options).points.map{|x, y| [Time.at(x).to_date.to_s, y]}
  end

  private

  def orthogonal_distance(point, line_start, line_end)
    numerator = ((line_end[0] - line_start[0]) * (line_start[1] - point[1]) - (line_start[0] - point[0]) * (line_end[1] - line_start[1]))
    denominator = (line_end[0] - line_start[0])**2 + (line_end[1] - line_start[1])**2
    numerator.abs / denominator**0.5
  end

  def calculate_points(points)
    return points if points.length < 3

    maximum_distance = 0
    index = 0

    (1..(points.length - 1)).each do |i|
      current_distance = orthogonal_distance(points[i], points.first, points.last)
      if current_distance > maximum_distance
        index = i
        maximum_distance = current_distance
      end
    end

    if maximum_distance >= @threshold
      results_1 = calculate_points(points[0..index])
      results_2 = calculate_points(points[index..-1])

      results_1[0..-2] + results_2
    else
      [points.first, points.last]
    end
  end

end
