require 'rails_helper'

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
      # set
      # # month   BCWS (planned_value)     BCWP (earned_value)
      #   5             1500                    1360
      #   6             2000                    1830
      #   7             2500                    2260
      #   8             2950
      #   9             3350
      it "returns the expected values" do
        # 7 months from 01/07/2017:
        #Default Issue status
        # default_issue_status = IssueStatus.create(name: "Nueva", is_closed: false, position: 1, default_done_ratio: nil)
        # default_issue_status.attributes = {name: "New", locale: :en}
        # default_issue_status.attributes = {name: "Nueva", locale: :es}
        # default_issue_status.save!
        #
        # pro =IssueStatus.create(name: "En progreso", is_closed: false, position: 2, default_done_ratio: nil)
        # pro.attributes = {name: "In progress", locale: :en}
        # pro.attributes = {name: "En progreso", locale: :es}
        # pro.save!
        #
        # clo = IssueStatus.create(name: "Cerrada", is_closed: true, position: 3, default_done_ratio: 100)
        # clo.attributes = {name: "Closed", locale: :en}
        # clo.attributes = {name: "Cerrada", locale: :es}
        # clo.save!
        #
        # rej = IssueStatus.create(name: "Rechazada", is_closed: false, position: 4, default_done_ratio: nil)
        # rej.attributes = {name: "Rejected", locale: :en}
        # rej.attributes = {name: "Rechazada", locale: :es}
        # rej.save!
        #
        # mt = Tracker.create(name: "Hito", position: 1, is_in_roadmap: true, default_status_id: default_issue_status.id)
        # mt.attributes = {name: "Milestone", locale: :en}
        # mt.attributes = {name: "Hito", locale: :es}
        # mt.save!
        #
        # ts = Tracker.create(name: "Tarea", position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id)
        # ts.attributes = {name: "Task", locale: :en}
        # ts.attributes = {name: "Tarea", locale: :es}
        # ts.save!


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
        issue5 = FactoryGirl.create(:issue, project: project)
        issue5.send("#{issue_evm_field}=", 1500)
        issue5.due_date = Time.now
        issue5.start_date = Time.now
        issue5.save!
        # set EV month 5
        entry5 = FactoryGirl.build(:time_entry, issue: issue5)
        # PV = 1500
        # EV = 1360
        # AC = ?
        # AC = PV * (EV/100)
        # 1500*x  = 1360 = ac
        entry5.send("#{entry_evm_field}=", 1360)
        entry5.save!
        issue5.done_ratio = (1360.0/1500.0)*100
        issue5.save!
        # Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 6
        Timecop.travel(initial_time + (6*evm_frequency).days)
        # Set PV month 6
        issue6 = FactoryGirl.create(:issue, project: project)
        issue6.send("#{issue_evm_field}=", 2000-1500)
        issue6.due_date = Time.now
        issue6.start_date = Time.now
        issue6.save!
        # set EV month 6
        entry6 = FactoryGirl.build(:time_entry, issue: issue5)
        entry6.send("#{entry_evm_field}=", 1830-1360)
        entry6.save!
        issue6.done_ratio = (entry6.send(entry_evm_field)/1830.0)*100
        issue6.save!
        # Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 7
        Timecop.travel(initial_time + (7*evm_frequency).days)
        # Set PV month 7
        issue7 = FactoryGirl.create(:issue, project: project)
        issue7.send("#{issue_evm_field}=", 2500-2000)
        issue7.due_date = Time.now
        issue7.start_date = Time.now
        issue7.save!
        # set EV month 7
        entry7 = FactoryGirl.build(:time_entry, issue: issue5)
        entry7.send("#{entry_evm_field}=", 2260-1830)
        entry7.save!
        issue7.done_ratio = (entry7.send(entry_evm_field)/2260.0)*100
        issue7.save!

        # Set PV month 8
        month_8_date = initial_time + (8*evm_frequency).days
        issue8 = FactoryGirl.create(:issue, project: project)
        issue8.send("#{issue_evm_field}=", 2950-2500)
        issue8.due_date = month_8_date
        issue8.start_date = month_8_date
        issue8.save!

        # Set PV month 9
        month_9_date = initial_time + (9*evm_frequency).days
        issue9 = FactoryGirl.create(:issue, project: project)
        issue9.send("#{issue_evm_field}=", 3350-2950)
        issue9.due_date = month_9_date
        issue9.start_date = month_9_date
        issue9.save!

        # Set PV month 10
        month_10_date = initial_time + (10*evm_frequency).days
        issue10 = FactoryGirl.create(:issue, project: project)
        issue10.send("#{issue_evm_field}=", 3650-3350)
        issue10.due_date = month_10_date
        issue10.start_date = month_10_date
        issue10.save!

        # Set PV month 11
        month_11_date = initial_time + (11*evm_frequency).days
        issue11 = FactoryGirl.create(:issue, project: project)
        issue11.send("#{issue_evm_field}=", 3900-3650)
        issue11.due_date = month_11_date
        issue11.start_date = month_11_date
        issue11.save!


                # Set PV month 12
        month_12_date = initial_time + (12*evm_frequency).days
        issue12 = FactoryGirl.create(:issue, project: project)
        issue12.send("#{issue_evm_field}=", 4000-3900)
        issue12.due_date = month_12_date
        issue12.start_date = month_12_date
        issue12.save!        
        
        
        

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
        expect(point.earned_schedule.ceil_to(2)).to eq(6.52)
        expect(point.es_schedule_variance.ceil_to(2)).to eq(-0.48)
        expect(point.es_schedule_performance_index.round(2)).to eq(0.93)
        expect(point.es_independent_time_estimate_at_compete.ceil_to(1)).to eq(12.9)

        puts "estimated_completion_date: #{point.estimated_completion_date}"
      end
    end
  end
end
