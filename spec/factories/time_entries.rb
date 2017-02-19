FactoryGirl.define do
  factory :time_entry do
    activity { TimeEntryActivity.where(name: "Desarrollo").first }
    spent_on { Time.now }
    user { User.where(login: "test").first }
  end
end
