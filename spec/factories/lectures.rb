FactoryBot.define do
  factory :lecture do
    name { "SWTII" }
    enrollment_key { "ruby" }
    is_running { true }
  end
end
