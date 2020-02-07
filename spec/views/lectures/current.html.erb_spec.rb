require "rails_helper"

RSpec.describe "lectures/current", type: :view do
  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer, email: "test@test.de")
    @course = FactoryBot.create(:course)
    @lectures = assign(:lectures, [
      Lecture.create!(
        name: "running lecture",
        enrollment_key: "Enrollment Key",
        status: "running",
        lecturer: @lecturer,
        course: @course,
        date: Date.today,
        start_time: DateTime.now,
        end_time: DateTime.now + 20.minutes
      ),
      Lecture.create!(
        name: "not running lecture",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: @lecturer,
        course: @course,
        date: Date.tomorrow,
        start_time: "2020-01-01 10:10:00",
        end_time: "2020-01-01 10:20:00"
      )
    ])
  end

  it "renders a list of all running lectures" do
    login_student
    visit current_lectures_path(course_id: @course.id)
    expect(page).to have_css("td", text: @lectures[0].name)
    expect(page).to_not have_css("td", text: @lectures[1].name)
  end

  it "provides a join button" do
    login_student
    visit current_lectures_path(course_id: @course.id)
    have_selector("input[type=submit][value='Join']")
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
  end
end
