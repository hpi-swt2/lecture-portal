require "rails_helper"

describe "The course detail page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being signed in as a lecturer that created a lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer, course: @course)
      sign_in @lecturer
    end

    it "should have a \"Start\" button for not started lectures" do
      visit(course_path(@course))
      expect(page).to have_link("Start")
    end

    it "should not have a \"View\" link for not started lectures" do
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should have a \"Create Lecture\" button" do
      visit(course_path(@course))
      expect(page).to have_link("Create Lecture")
    end

    it "should set the lecture active on clicking \"Start\"" do
      visit(course_path(@course))
      click_on("Start")
      @lecture.reload
      expect(@lecture.status).to eq("running")
    end

    it "should redirect to the show path after clicking \"Start\"" do
      visit(course_path(@course))
      click_on("Start")
      expect(current_path).to eq(course_lecture_path(@course, @lecture))
    end

    it "should not show the \"Start\" button after a lecture was started" do
      visit(course_path(@course))
      click_on("Start")
      expect(page).not_to have_link("Start")
    end

    it "should show a \"View\" link after the lecture is started" do
      @lecture.update(status: "running")
      visit(course_path(@course))
      expect(page).to have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should not show lectures of other lecturers" do
      course2 = FactoryBot.create(:course)
      lecture2 = FactoryBot.create(:lecture, course: course2)
      lecture2.update(status: "running")
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(course2, lecture2))
    end

    it "should have an \"edit\" button." do
      visit course_path(@course)
      expect(page).to have_link("Edit", href: edit_course_lecture_path(:course_id => @course.id, :id => @lecture.id))
    end

    it "should redirect to current course page when accessed by a student" do
      @student = FactoryBot.create(:user, :student)
      @course.join_course(@student)
      sign_in @student
      visit(course_lecture_path(:course_id => @course.id, :id => @lecture.id))
      expect(page).to have_current_path(course_path(@course))
    end
  end
end
