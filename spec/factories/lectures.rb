FactoryBot.define do
  factory :lecture do
    name { "SWT2" }
    enrollment_key { "ruby" }
    lecturer { FactoryBot.create(:user, :lecturer) }
    course { FactoryBot.create(:course) }
    date { Date.tomorrow }
    start_time { DateTime.now + 1.hour }
    end_time { DateTime.now + 2.hours }
  end

  trait :keyless do
    enrollment_key { }
  end
end
