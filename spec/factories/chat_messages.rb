FactoryGirl.define do
  factory :chat_message do
    body "MyText"
    conversation nil
    user nil
  end
end
