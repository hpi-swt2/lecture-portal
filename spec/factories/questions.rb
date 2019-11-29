# TODO: add student to FactoryBot
FactoryBot.define do
  factory :question do
    content { "Question" }
    author { FactoryBot.create(:user) }
  end
end
