FactoryGirl.define do
  factory :issue do
    status do
      default_issue_status = IssueStatus.where(name: "New").first
      if default_issue_status.nil?
        default_issue_status = IssueStatus.create(name: "Nueva", is_closed: false, position: 1, default_done_ratio: nil)
        default_issue_status.attributes = {name: "New", locale: :en}
        default_issue_status.attributes = {name: "Nueva", locale: :es}
        default_issue_status.save!
      end
      default_issue_status
    end
    sequence(:subject){|n| "subject#{n}" }
    tracker do
      ts = Tracker.where(name: "Task").first
      if ts.nil?
        ts = Tracker.create(name: "Tarea", position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id)
        ts.attributes = {name: "Task", locale: :en}
        ts.attributes = {name: "Tarea", locale: :es}
        ts.save!
      end
      ts
    end
    author do
      user = User.where(login: "test").first
      if user.nil?
        user = User.new(login: "test", mail: "test@test.com", firstname: "teste", lastname: "asd")
        user.save!
      end
      user
    end
  end
end
      #  Validation failed: Subject cannot be blank, Tracker cannot be blank, Author cannot be blank, Tracker is not included in the list
