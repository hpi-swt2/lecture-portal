FactoryBot.define do
  factory :user do
    email { random_name + "@hpi.de" }
    password { "password" }
    password_confirmation { "password" }

    trait :student do
      is_student { true }
    end
    trait :lecturer do
      is_student { false }
    end
  end
end

def random_name
  ("a".."z").to_a.shuffle.join
end
