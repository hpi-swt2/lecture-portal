FactoryBot.define do
    factory :lecture_comprehension_stamp do
      status { 0 }
      user { FactoryBot.create(:user, :student) }
      lecture { FactoryBot.create(:lecture, lecturer: FactoryBot.create(:user, :lecturer)) }
    end
  end
