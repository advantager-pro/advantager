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

require 'SVG/Graph/Plot'

module SVG
  module Graph
    # === For creating SVG plots of scalar temporal data
    #
    # = Synopsis
    #
    #   require 'svg/graph/agile_time_series'
    #
    #   # Data sets are x,y pairs
    #   data1 = ["6/17/72", 11,    "1/11/72", 7,    "4/13/04 17:31", 11,
    #           "9/11/01", 9,    "9/1/85", 2,    "9/1/88", 1,    "1/15/95", 13]
    #   data2 = ["8/1/73", 18,    "3/1/77", 15,    "10/1/98", 4,
    #           "5/1/02", 14,    "3/1/95", 6,    "8/1/91", 12,    "12/1/87", 6,
    #           "5/1/84", 17,    "10/1/80", 12]
    #
    #   graph = SVG::Graph::AgileTimeSeries.new( {
    #     :width => 640,
    #     :height => 480,
    #     :graph_title => title,
    #     :show_graph_title => true,
    #     :no_css => true,
    #     :key => true,
    #     :scale_x_integers => true,
    #     :scale_y_integers => true,
    #     :min_x_value => 0,
    #     :min_y_value => 0,
    #     :show_data_labels => true,
    #     :show_x_guidelines => true,
    #     :show_x_title => true,
    #     :x_title => "Time",
    #     :show_y_title => true,
    #     :y_title => "Ice Cream Cones",
    #     :y_title_text_direction => :bt,
    #     :stagger_x_labels => true,
    #     :x_label_format => "%m/%d/%y",
    #   })
    #
    #   graph.add_data({
    #   	:data => projection
    # 	  :title => 'Projected',
    #   })
    #
    #   graph.add_data({
    #   	:data => actual,
    # 	  :title => 'Actual',
    #   })
    #
    #   print graph.burn()
    #
    # = Description
    #
    # Produces a graph of temporal scalar data.
    #
    # = Examples
    #
    # http://www.germane-software/repositories/public/SVG/test/timeseries.rb
    #
    # = Notes
    #
    # The default stylesheet handles upto 10 data sets, if you
    # use more you must create your own stylesheet and add the
    # additional settings for the extra data sets. You will know
    # if you go over 10 data sets as they will have no style and
    # be in black.
    #
    # Unlike the other types of charts, data sets must contain x,y pairs:
    #
    #   [ "12:30", 2 ]          # A data set with 1 point: ("12:30",2)
    #   [ "01:00",2, "14:20",6] # A data set with 2 points: ("01:00",2) and
    #                           #                           ("14:20",6)
    #
    # Note that multiple data sets within the same chart can differ in length,
    # and that the data in the datasets needn't be in order; they will be ordered
    # by the plot along the X-axis.
    #
    # The dates must be parseable by ParseDate, but otherwise can be
    # any order of magnitude (seconds within the hour, or years)
    #
    # = See also
    #
    # * SVG::Graph::Graph
    # * SVG::Graph::BarHorizontal
    # * SVG::Graph::Bar
    # * SVG::Graph::Line
    # * SVG::Graph::Pie
    # * SVG::Graph::Plot
    #
    # == Author
    #
    # Sean E. Russell <serATgermaneHYPHENsoftwareDOTcom>
    #
    # Copyright 2004 Sean E. Russell
    # This software is available under the Ruby license[LICENSE.txt]
    #
    class AgileTimeSeries < Plot
      # In addition to the defaults set by Graph::initialize and
      # Plot::set_defaults, sets:
      # [x_label_format] '%Y-%m-%d %H:%M:%S'
      # [popup_format]  '%.2f'
      def set_defaults
        super
        init_with(
          #:max_time_span     => '',
          :x_label_format     => '%Y-%m-%d %H:%M:%S',
          :popup_format       => "%.2f",
          :scale_x_divisions  => 1
        )
      end

      # The format string use do format the X axis labels.
      # See Time::strformat
      attr_accessor :x_label_format
      # Use this to set the spacing between dates on the axis.  The value
      # must be of the form
      # "\d+ ?(days|weeks|months|years|hours|minutes|seconds)?"
      #
      # EG:
      #
      #   graph.timescale_divisions = "2 weeks"
      #
      # will cause the chart to try to divide the X axis up into segments of
      # two week periods.
      attr_accessor :timescale_divisions
      # The formatting used for the popups.  See x_label_format
      attr_accessor :popup_format

      # Add data to the plot.
      #
      #   d1 = [ "12:30", 2 ]          # A data set with 1 point: ("12:30",2)
      #   d2 = [ "01:00",2, "14:20",6] # A data set with 2 points: ("01:00",2) and
      #                                #                           ("14:20",6)
      #   graph.add_data(
      #     :data => d1,
      #     :title => 'One'
      #   )
      #   graph.add_data(
      #     :data => d2,
      #     :title => 'Two'
      #   )
      #
      # Note that the data must be in time,value pairs, and that the date format
      # may be any date that is parseable by ParseDate.
      # def add_data data
      #   @data = [] unless @data

      #   raise "No data provided by #{@data.inspect}" unless data[:data] and
      #                                               data[:data].kind_of? Array
      #   raise "Data supplied must be x,y pairs!  "+
      #     "The data provided contained an odd set of "+
      #     "data points" unless data[:data].length % 2 == 0
      #   return if data[:data].length == 0


      #   x = []
      #   y = []
      #   data[:data].each_index {|i|
      #     if i%2 == 0
      #       t = DateTime.parse( data[:data][i] ).to_time
      #       x << t.to_i
      #     else
      #       y << data[:data][i]
      #     end
      #   }
      #   sort( x, y )
      #   data[:data] = [x,y]
      #   @data << data
      # end


      protected

      def format x, y
        popup_format % y.to_f
      end

      def get_x_labels
        @config[:fields]
      end

      def x_range
        max_value = get_x_labels.count - 1
        min_value = 0
        min_value = min_value<min_x_value ? min_value : min_x_value if min_x_value

        range = max_value - min_value
        right_pad = range == 0 ? 10 : range / 20.0
        scale_range = (max_value + right_pad) - min_value

        scale_division = scale_x_divisions || (scale_range / 10.0)

        if scale_x_integers
          scale_division = scale_division < 1 ? 1 : scale_division.round
        end

        [min_value, max_value, scale_division]
      end

      private

      def field_width
        values = get_x_values
        max = [@data.collect{|x| x[:data][X][-1]}.max, values.max].max
        dx = (max - values[-1]).to_f / (values[-1] - values[-2])
        (@graph_width.to_f - font_size*2*right_font) /
          (values.length + dx - right_align)
      end

      def get_y_values
        min_value, max_value, scale_division = y_range
        rv = []
        min_value.step( max_value, scale_division ) {|v| rv << (v * 100).round / 100.0}
        return rv
      end
      alias :get_y_labels :get_y_values

      def get_x_values
        rv = []
        min, max, scale_division = x_range
        if timescale_divisions
          timescale_divisions =~ /(\d+) ?(day|week|month|year|hour|minute|second)?/
          division_units = $2 ? $2 : "day"
          amount = $1.to_i
          if amount
            step =  nil
            case division_units
            when "month"
              cur = min
              while cur < max
                rv << cur
                arr = Time.at( cur ).to_a
                arr[4] += amount
                if arr[4] > 12
                  arr[5] += (arr[4] / 12).to_i
                  arr[4] = (arr[4] % 12)
                end
                cur = Time.local(*arr).to_i
              end
            when "year"
              cur = min
              while cur < max
                rv << cur
                arr = Time.at( cur ).to_a
                arr[5] += amount
                cur = Time.local(*arr).to_i
              end
            when "week"
              step = 7 * 24 * 60 * 60 * amount
            when "day"
              step = 24 * 60 * 60 * amount
            when "hour"
              step = 60 * 60 * amount
            when "minute"
              step = 60 * amount
            when "second"
              step = amount
            end
            min.step( max, step ) {|v| rv << v} if step

            return rv
          end
        end
        min.step( max, scale_division ) {|v| rv << v}
        return rv
      end

    end
  end
end
