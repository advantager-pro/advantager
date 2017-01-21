FactoryGirl.define do
  factory :project do
    id 1
    name "MyString"
    description "MyText"
    homepage "MyString"
    is_public false
    parent_id nil
    created_on "2017-01-21 20:51:51"
    updated_on "2017-01-21 20:51:51"
    identifier "MyString"
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
  end
end
