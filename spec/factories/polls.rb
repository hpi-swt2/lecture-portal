FactoryBot.define do
  factory :poll do
    title { "MyString" }
    is_multiselect { false }
    is_active { true }
    lecture_id { FactoryBot.create(:lecture).id }
    trait :active do
      is_active { true }
    end
    trait :inactive do
      is_active { false }
    end
  end
end
