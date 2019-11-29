FactoryBot.define do
  factory :poll do
    title { "MyString" }
    is_multiselect { false }
    is_active { true }
  end
end
