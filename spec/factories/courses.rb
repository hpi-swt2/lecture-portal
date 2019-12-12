FactoryBot.define do
  factory :course do
    name { "MyCourse" }
    description { "Very long descriptive text" }
    is_open { true }
    creator { FactoryBot.create(:user, :lecturer) }
  end
end
