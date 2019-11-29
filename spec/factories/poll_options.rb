FactoryBot.define do
  factory :poll_option do
    description { "Example description" }
    poll { build :poll }
  end
end
