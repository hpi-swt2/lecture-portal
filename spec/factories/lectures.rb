FactoryBot.define do
  factory :lecture do
    name { "SWTII" }
    enrollment_key { "ruby" }
    lecturer { FactoryBot.create(:user, :lecturer) }
  end
end
