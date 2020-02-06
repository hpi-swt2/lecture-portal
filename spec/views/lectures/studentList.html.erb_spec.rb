require "rails_helper"

RSpec.describe "lectures/studentList", type: :view do
  include Devise::TestHelpers
  let(:valid_session) { {} }
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  enrollment_key: "Enrollment Key",
                                  status: "running",
                                  lecturer: FactoryBot.create(:user, :lecturer),
                                  course: @course,
                                  date: Date.today,
                                  start_time: DateTime.now,
                                  end_time: DateTime.now + 20.minutes
    ))
  end

  describe "as a lecturer" do
    before(:each) do
      @current_user = @lecture.lecturer
      sign_in @lecture.lecturer
    end

    it "shows list of participating students" do
      user = FactoryBot.create(:user, :student, email: "student@mail.com")
      @course.join_course(user)
      @lecture.join_lecture(user)
      render
      expect(rendered).to have_text("student@mail.com")
    end
  end
end