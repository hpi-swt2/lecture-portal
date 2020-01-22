require "rails_helper"

describe "The current lectures page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being logged in as a student" do
    before(:each) do
      @student = FactoryBot.create(:user, :student)
      @course = FactoryBot.create(:course)
      sign_in @student
    end

    it "should be viewable for a course" do
      visit current_lectures_path(course_id: @course.id)
      expect(page).to have_current_path(current_lectures_path(course_id: @course.id))
    end

    it "should only show active lectures" do
      @lectures = FactoryBot.create_list(:lecture, 2)
      @lectures[0].update(status: "created")
      @lectures[0].update(course: @course)
      @lectures[1].update(status: "running", name: "Other name")
      @lectures[1].update(course: @course)

      visit current_lectures_path(course_id: @course.id)
      expect(page).to_not have_css("td", text: @lectures[0].name)
      expect(page).to have_css("td", text: @lectures[1].name)
    end

    it "clicking the join button adds the student to the keyless lecture" do
      @lecture = FactoryBot.create(:lecture, enrollment_key: nil, status: "running", course: @course)
      visit current_lectures_path(course_id: @course.id)
      expect(@lecture.participating_students.length).to be 0
      click_on("Join")
      @lecture.reload
      expect(@lecture.participating_students.length).to be 1
      expect(@lecture.participating_students[0]).to eq @student
    end
  end

  context "being logged in as a lecturer" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      sign_in @lecturer
      @course = FactoryBot.create(:course)
    end

    it "should not be viewable" do
      visit current_lectures_path(course_id: @course.id)
      expect(page).to_not have_current_path(current_lectures_path(course_id: @course.id))
    end
  end
end
