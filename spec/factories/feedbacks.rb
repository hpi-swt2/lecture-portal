FactoryBot.define do
  factory :feedback do
    content { "My Feedback" }
    lecture { FactoryBot.create(:lecture) }
  end
end
