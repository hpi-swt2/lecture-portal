FactoryBot.define do
  factory :question do
    content { "Question" }
    author { FactoryBot.create(:user, :student) }
    lecture { FactoryBot.create(:lecture, :lecturer => :author) }
  end
end
