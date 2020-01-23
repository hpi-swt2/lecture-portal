FactoryBot.define do
  factory :feedback do
    content { "My Feedback" }
    lecture { FactoryBot.create(:lecture) }
    user { FactoryBot.create(:user, :student)}
  end
end
