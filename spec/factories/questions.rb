FactoryBot.define do
  factory :question do
    content { "Question" }
    author { FactoryBot.create(:user, :student) }
  end
end
