require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    assign(:lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer),
        course: @course
      ),
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer),
        course: @course
      )
    ])
  end
end
