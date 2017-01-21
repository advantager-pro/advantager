require 'rails_helper'

RSpec.describe Project, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "earned_schedule" do
    let(:evm_field){ 'point' }
    let(:project){ FactoryGirl.build(:project, evm_field: evm_field) }
    let(:issue_evm_field){ project.issue_evm_field }
    let(:entry_evm_field){ project.entry_evm_field }
    let(:initial_time){ Time.local(2017, 1, 1) }
    context "
    # # month   BCWS (planned_value)     BCWP (earned_value)
    #   5             1500                    1360
    #   6             2000                    1830
    #   7 (current)   2500                    2260
    #   8             2950
    #   9             3350
    " do
      before do
        # 7 months from 01/07/2017:

        Timecop.travel(initial_time)
        # start the project
        project.save!
        issue1 = Issue.create(project: project)
        issue1.start_date = Time.now
        
        # Set PV for each month until 9
        Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 5
        Timecop.travel(initial_time + 5.monts)
        # Set PV month 5
        issue5 = Issue.create(project: project)
        issue5.send(issue_evm_field, 1500)
        issue5.due_date = Time.now
        issue5.start_date = Time.now
        issue5.save!
        # set EV month 5
        entry5 = TimeEntry.create(issue: issue5)
        entry5.send(entry_evm_field, 1360)
        entry5.save!
        Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 6
        Timecop.travel(initial_time + 6.months)
        # Set PV month 6
        issue6 = Issue.create(project: project)
        issue6.send(issue_evm_field, 2000-1500)
        issue6.due_date = Time.now
        issue6.start_date = Time.now
        issue6.save!
        # set EV month 6
        entry6 = TimeEntry.create(issue: issue5)
        entry6.send(entry_evm_field, 1830-1360)
        entry6.save!
        Advantager::EVM::Point.generate_from_project_begining(project)
        # Go to month 7
        Timecop.travel(initial_time + 7.months)
        # Set PV month 7
        issue7 = Issue.create(project: project)
        issue7.send(issue_evm_field, 2500-2000)
        issue7.due_date = Time.now
        issue7.start_date = Time.now
        issue7.save!
        # set EV month 7
        entry7 = TimeEntry.create(issue: issue5)
        entry7.send(entry_evm_field, 2260-1830)
        entry7.save!

        # Set PV month 8
        month_8_date = initial_time + 8.months
        issue8 = Issue.create(project: project)
        issue8.send(issue_evm_field, 2950-2500)
        issue8.due_date = month_8_date
        issue8.start_date = month_8_date
        issue8.save!

        # Set PV month 9
        month_9_date = initial_time + 9.months
        issue9 = Issue.create(project: project)
        issue9.send(issue_evm_field, 3350-2950)
        issue9.due_date = month_9_date
        issue9.start_date = month_9_date
        issue9.save!

        Advantager::EVM::Point.generate_from_project_begining(project)
      end
      # set
      # # month   BCWS (planned_value)     BCWP (earned_value)
      #   5             1500                    1360
      #   6             2000                    1830
      #   7             2500                    2260
      #   8             2950
      #   9             3350
      it "returns the expected values" do
        expect(project.current_period).to eq(7)
        expect(project.earned_schedule).to eq(6.52)
        expect(project.es_schedule_variance).to eq(-0.48)
        expect(project.es_schedule_performance_index).to eq(0.93)
        expect(project.es_independent_time_estimate_at_compete).to eq(12.90)
      end
    end
  end
end
