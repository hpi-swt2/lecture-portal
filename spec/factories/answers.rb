FactoryBot.define do
  factory :answer do
    poll_id { build :poll}
    student_id {1}
    lecture_id {1}
  end
end
