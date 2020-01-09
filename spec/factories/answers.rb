FactoryBot.define do
  factory :answer do
    poll { build :poll }
    student { build :student }
  end
end
