require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "earned_schedule" do
    let(:evm_field){ 'point' }
    let(:evm_frequency){ 5 }
    let(:initial_time){ Time.local(2017, 1, 1) }

    context "when the current date is: 01/01/2017 " do

      before do
        Project.all.each{  |p| p.evm_points.destroy_all }
        Project.destroy_all
        Timecop.travel(initial_time)
      end

      let(:project)  { FactoryGirl.create(:project, evm_field: evm_field, evm_frequency: evm_frequency, created_on: Time.now) }
      let(:issue_evm_field){ project.issue_evm_field }
      let(:entry_evm_field){ project.entry_evm_field }
      let(:earned_schedule_expectations) do
        {
          # current_period: 7,
          earned_schedule: 6.52,
          es_schedule_variance: -0.48,
          es_schedule_performance_index: 0.93,
          es_independent_time_estimate_at_compete: 12.9
        }
      end

      context "
          # # period   BCWS (planned_value)     BCWP (earned_value)
          #   5             1500                    1360
          #   6             2000                    1830
          #   7 (current)   2500                    2260
          #   8             2950
          #   9             3350
          #   10            3650
          #   11            3900
          #   12            4000
          " do
            let(:periods) do
              {
                "1" => { planned_value: 100, earned_value: 98 }, 
                "2" => { planned_value: 350, earned_value: 325 }, 
                "3" => { planned_value: 650, earned_value: 600 }, 
                "4" => { planned_value: 1050, earned_value: 960 }, 
                "5" => { planned_value: 1500, earned_value: 1360 }, 
                "6" => { planned_value: 2000, earned_value: 1830 },
                "7" => { planned_value: 2500, earned_value: 2260 }, #7
                "8" => { planned_value: 2950 }, #8
                "9" => { planned_value: 3350 }, # 9
                "10" => { planned_value: 3650 }, # 10
                "11" => { planned_value: 3900 }, # 11
                "12" => { planned_value: 4000 } # 12
               }
            end

            it "returns the expected values" do
              # Start the project
              issue1 = FactoryGirl.create(:issue, project: project, start_date: Time.now)
              puts "", "  Period      |       planned value      |    earned value"

              periods.each do |period, values|
                # time travel to that specific period
                Timecop.travel(initial_time + (period.to_i*evm_frequency).days )  #  + evm_frequency ?
                # Add EVM entries (issues, logs, etc)
                add_evm_for(project, period, periods)
                # reload the project to get the updated EVM values
                project.reload
                # byebug
                
                # check
                puts "     #{period}#{period.to_i < 10 ? ' ' : ''}       |           #{values[:planned_value]}           |      #{values[:earned_value]}"
                expect(project.planned_value).to eq(values[:planned_value])
                expect(project.earned_value.round).to eq(values[:earned_value]) if values[:earned_value].present?
              end

              # go a bit after 7 periods
              Timecop.travel(initial_time + (7*evm_frequency).days )

              Advantager::EVM::Point.generate_from_project_begining(project)
              point = Advantager::EVM::Point.last
              byebug

              # check earned_schedule calculus
              earned_schedule_expectations.each do |field, value|
                puts "", "Expected #{field}: #{point.send(field)} to be #{value}"
                precision = field == :es_independent_time_estimate_at_compete ? 1 : 2
                expect(point.send(field).round(precision)).to eq(value)
              end

              Timecop.travel(initial_time + (17*evm_frequency).days )
              point = Advantager::EVM::Point.last


              old_point_estimated_completion_date = point.estimated_completion_date
              old_point_es = point.earned_schedule

              # update frequency
              project.evm_frequency = 2
              project.save!
              Advantager::EVM::Point.generate_from_project_begining(project)
              point = Advantager::EVM::Point.last.reload
              point_w_2_freq_estimated_completion_date = point.estimated_completion_date
              point_w_2_freq_earned_schedule = point.earned_schedule

              byebug


              # update frequency again!
              project.evm_frequency = 13
              project.save!
              Advantager::EVM::Point.generate_from_project_begining(project)
              new_point = Advantager::EVM::Point.last.reload

              puts "old_point date #{old_point_estimated_completion_date}"
              puts "point_w_2_freq date #{point_w_2_freq_estimated_completion_date}"
              puts "new_point date #{new_point.estimated_completion_date}"

              byebug

              expect(point_w_2_freq_earned_schedule).to eq(old_point_es)
              expect(new_point.earned_schedule).to eq(old_point_es)

              expect(old_point_estimated_completion_date).to eq(new_point.estimated_completion_date)
              expect(old_point_estimated_completion_date).to eq(point_w_2_freq_estimated_completion_date)
          end
        end
    end
  end
end

def add_evm_for(project, period, periods)
  current = periods[period]
  previous = periods[(period.to_i - 1).to_s] || {}
  planned_value = current[:planned_value]-(previous[:planned_value] || 0.0)
  issue = FactoryGirl.create(:issue, project: project,
    :"#{project.issue_evm_field}" => planned_value, due_date: Time.now, start_date: Time.now)
  if current[:earned_value].present?
    actual_cost = current[:earned_value] - (previous[:earned_value] || 0.0)
    # entry = 
    FactoryGirl.create(:time_entry, issue: issue, :"#{project.entry_evm_field}" => actual_cost)
    dnratio = (actual_cost*100.0) / issue.planned_value
    issue.done_ratio = dnratio
    byebug unless issue.save
    issue.save!
  end
end
