FactoryBot.define do
  factory :poll do
    title { "MyString" }
    is_multiselect { false }
    status { "running" }
    lecture_id { FactoryBot.create(:lecture).id }
    trait :active do
      status { "running" }
    end
    trait :inactive do
      status { "created" }
    end
    trait :single_select do
      is_multiselect { false }
    end
    trait :multi_select do
      is_multiselect { true }
    end
  end
end
