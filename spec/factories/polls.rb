FactoryBot.define do
  factory :poll do
    title { "MyString" }
    is_multiselect { false }
    lecture_id { FactoryBot.create(:lecture).id }
  end
end
