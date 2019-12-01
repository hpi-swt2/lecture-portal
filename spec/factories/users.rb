FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :another_user do
    email { "another_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
