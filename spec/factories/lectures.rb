FactoryBot.define do
  factory :lecture do
    name { "SWTII" }
    enrollment_key { "ruby" }
    description { "on rails" }
    lecturer { FactoryBot.create(:user, :lecturer) }
  end
end
