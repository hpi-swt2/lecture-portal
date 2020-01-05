FactoryBot.define do
  factory :course do
    name { "SWT2" }
    description { "ruby" }
    creator { FactoryBot.create(:user, :lecturer) }
  end
end
