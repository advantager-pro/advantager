FactoryGirl.define do
  factory :project do
    # id 1
    name "MyString"
    description "MyText"
    homepage "MyString"
    is_public false
    parent_id nil
    created_on "2017-01-21 20:51:51"
    updated_on "2017-01-21 20:51:51"
    identifier "mystring"
    status ::Project::STATUS_ACTIVE
    lft nil
    rgt nil
    inherit_members false
    default_version_id nil
    visible_fields []
    evm_field ::Project.available_fields.last
    currency "MyString"
    custom_unity "MyString"
    evm_frequency 1
    trackers do
      ts = Tracker.where(name: "Task").first
      if ts.nil?
        ts = Tracker.create(name: "Tarea", position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id)
        ts.attributes = {name: "Task", locale: :en}
        ts.attributes = {name: "Tarea", locale: :es}
        ts.save!
      end
      [ts]
    end
  end
end
