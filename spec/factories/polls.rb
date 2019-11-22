FactoryBot.define do
  factory :poll do
    title { "MyString" }
    is_multiselect { false }
    lecture { FactoryBot.build :lecture }
  end
end
