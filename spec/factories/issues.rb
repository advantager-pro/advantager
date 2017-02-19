FactoryGirl.define do
  factory :issue do
    status { IssueStatus.where(name: "New").first }
    sequence(:subject){|n| "subject#{n}" }
    tracker { Tracker.where(name: "Task").first }
    author { User.where(login: "test").first }
  end
end
