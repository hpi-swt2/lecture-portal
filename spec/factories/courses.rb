FactoryBot.define do
  factory :course do
    name { "MyCourse" }
    description { "Very long descriptive text" }
    #creator { FactoryBot.build(:user, :lecturer) }
  end
end