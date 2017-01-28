FactoryGirl.define do
  factory :time_entry do
    activity do
      dev = TimeEntryActivity.where(name: "Desarrollo").first
      dev ||= TimeEntryActivity.where(name: "Development").first
      if dev.nil?
        dev = TimeEntryActivity.create(name: "Desarrollo", position: 2, is_default: true, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
        dev.attributes = {name: "Development", locale: :en}
        dev.attributes = {name: "Desarrollo", locale: :es}
        dev.save!
      end
      dev
    end
    spent_on { Time.now }
    user do
      user = User.where(login: "test").first
      if user.nil?
        user = User.new(login: "test", mail: "test@test.com", firstname: "teste", lastname: "asd")
        user.save!
      end
      user
    end
  end
end
