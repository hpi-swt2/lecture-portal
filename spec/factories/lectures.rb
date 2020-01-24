FactoryBot.define do
  factory :lecture do
    name { "SWT2" }
    enrollment_key { "ruby" }
    lecturer { FactoryBot.create(:user, :lecturer) }
    course { FactoryBot.create(:course) }
    date { "2020-02-02" }
    start_time { "2020-01-01 10:10:00" }
    end_time { "2020-01-01 10:20:00" }
  end

  trait :keyless do
    enrollment_key { }
  end
end
