require 'rails_helper'

def create_issue(project, planned_value, previous_planned_value=0, date=nil)
  issue = FactoryGirl.create(:issue, project: project)
  issue.send("#{project.issue_evm_field}=", planned_value-previous_planned_value)
  issue.due_date = date || Time.now
  issue.start_date = date || Time.now
  issue.save!
  issue
end

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end


RSpec.describe Project, type: :model do
  before(:all) do
    Advantager::EVM::BreakPoint.destroy_all
    Advantager::EVM::Point.destroy_all
    TimeEntry.destroy_all
    Issue.destroy_all
    Project.destroy_all
  end
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "earned_schedule" do
    let(:evm_field){ 'point' }
    let(:evm_frequency){ 1 }
    let(:project) do

     end

    let(:initial_time){ Time.local(2017, 1, 1) }
    context "
    # # month   BCWS (planned_value)     BCWP (earned_value)
    #   5             1500                    1360
    #   6             2000                    1830
    #   7 (current)   2500                    2260
    #   8             2950
    #   9             3350
    " do
      it "returns the expected values" do

        Timecop.travel(initial_time)
        # start the project

        project = FactoryGirl.create(:project, evm_field: evm_field, evm_frequency: evm_frequency, created_on: Time.now)
        issue_evm_field = project.issue_evm_field
        entry_evm_field = project.entry_evm_field

        issue1 = FactoryGirl.create(:issue, project: project, start_date: Time.now)
        # issue1.start_date = Time.now

        # Set PV for each month until 9
        # Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 5
        Timecop.travel(initial_time + (5*evm_frequency).days)
        # Set PV month 5
        issue5 = create_issue(project, 1500)
        # set EV month 5
        entry5 = FactoryGirl.build(:time_entry, issue: issue5)
        # PV = 1500
        # EV = 1360
        # AC = ?
        # AC = PV * (EV/100)
        # 1500*x  = 1360 = ac
        entry5.send("#{entry_evm_field}=", 1360)
        entry5.save!
        issue5.done_ratio = (1360.0*100.0)/ issue5.planned_value

        # puts 
        issue5.save!
        project.reload
        expect(project.planned_value).to eq(1500)
        expect(project.earned_value.round).to eq(1360)

        # Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 6
        Timecop.travel(initial_time + (6*evm_frequency).days)
        # Set PV month 6
        issue6 = create_issue(project, 2000, 1500) 
        
        # set EV month 6
        entry6 = FactoryGirl.build(:time_entry, issue: issue5)
        entry6.send("#{entry_evm_field}=", 1830-1360)
        entry6.save!
        issue6.done_ratio = ((1830-1360)*100.0)/ issue6.planned_value
        issue6.save!

        project.reload
        expect(project.planned_value).to eq(2000)
        expect(project.earned_value.round).to eq(1830)

        # Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 7
        Timecop.travel(initial_time + (7*evm_frequency).days)
        # Set PV month 7
        issue7 = create_issue(project, 2500, 2000) 
        # set EV month 7
        entry7 = FactoryGirl.build(:time_entry, issue: issue5)
        entry7.send("#{entry_evm_field}=", 2260-1830)
        entry7.save!
        issue7.done_ratio =  ((2260-1830)*100.0)/ issue7.planned_value # asdasddaadd ///////
        issue7.save!

        project.reload
        expect(project.planned_value).to eq(2500)
        expect(project.earned_value.round).to eq(2260)


        # Set PV month 8
        month_8_date = initial_time + (8*evm_frequency).days
        issue8 = create_issue(project, 2950, 2500, month_8_date) 

        project.reload
        expect(project.planned_value).to eq(2950)


        # Set PV month 9
        month_9_date = initial_time + (9*evm_frequency).days
        issue9 = create_issue(project, 3350, 2950, month_9_date) 

        project.reload
        expect(project.planned_value).to eq(3350)


        # Set PV month 10
        month_10_date = initial_time + (10*evm_frequency).days
        issue10 = create_issue(project, 3650, 3350, month_10_date)

        project.reload
        expect(project.planned_value).to eq(3650)


        # Set PV month 11
        month_11_date = initial_time + (11*evm_frequency).days
        issue11 = create_issue(project, 3900, 3650, month_11_date) 

        project.reload
        expect(project.planned_value).to eq(3900)

                # Set PV month 12
        month_12_date = initial_time + (12*evm_frequency).days
        issue12 = create_issue(project, 4000, 3900, month_12_date)
   
        project.reload
        expect(project.planned_value).to eq(4000)

     
        # go a bit after 7 months
        Timecop.travel(initial_time + (7*evm_frequency).days )#+ 1.day)

        Advantager::EVM::Point.generate_from_project_begining(project)

















        point = Advantager::EVM::Point.last

        puts "", ""
        puts "point count, #{point.class.count}"
        puts "current_period: #{point.current_period} ==? #{7}", ""
        puts "earned_schedule: #{point.earned_schedule.ceil_to(2)} ==? #{6.52}", ""
        puts "es_schedule_variance: #{point.es_schedule_variance.ceil_to(2)} ==? #{-0.48}", ""
        puts "es_schedule_performance_index: #{point.es_schedule_performance_index.ceil_to(2)} ==? #{0.93}", ""
        puts "es_independent_time_estimate_at_compete: #{point.es_independent_time_estimate_at_compete.ceil_to(2)} ==? #{12.90}", ""


        expect(point.current_period).to eq(7)
        expect(point.earned_schedule).to eq(6.52)
        expect(point.es_schedule_variance.ceil_to(2)).to eq(-0.48)
        expect(point.es_schedule_performance_index.round(2)).to eq(0.93)
        expect(point.es_independent_time_estimate_at_compete.ceil_to(1)).to eq(12.9)

        puts "estimated_completion_date: #{point.estimated_completion_date}"
      end
    end
  end
end
