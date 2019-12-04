FactoryBot.define do
  factory :lecture do
    name { "SWTII" }
    enrollment_key { "ruby" }
    lecturer { FactoryBot.create(:user, :lecturer, email: random_name + "@hpi.de") }
  end
end

def random_name
  ("a".."z").to_a.shuffle.join
end
