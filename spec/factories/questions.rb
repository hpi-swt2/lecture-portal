FactoryBot.define do
  factory :question do
    content { "Question" }
    author { FactoryBot.create(:user, :student) }
    lecture { FactoryBot.create(:lecture, lecturer: FactoryBot.create(:user, :lecturer)) }
  end
end
