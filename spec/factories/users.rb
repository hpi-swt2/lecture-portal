FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :student do
      is_student { true }
    end
    trait :lecturer do
      is_student { false }
    end
  end

  factory :another_user do
    email { "another_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
