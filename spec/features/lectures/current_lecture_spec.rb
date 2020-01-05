require "rails_helper"

describe "The current lectures page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being logged in as a student" do
    before(:each) do
      @student = FactoryBot.create(:user, :student)
      sign_in @student
    end

    it "should be viewable" do
      visit current_lectures_path
      expect(page).to have_current_path(current_lectures_path)
    end

    it "should only show active lectures" do
      @lectures = FactoryBot.create_list(:lecture, 2)
      @lectures[0].update(status: "created")
      @lectures[1].update(status: "running", name: "Other name")

      visit current_lectures_path
      expect(page).to_not have_css("td", text: @lectures[0].name)
      expect(page).to have_css("td", text: @lectures[1].name)
    end

    it "clicking the join button adds the student to the lecture" do
      @lecture = FactoryBot.create(:lecture, status: "running")
      visit current_lectures_path
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
    end

    it "should not be viewable" do
      visit current_lectures_path
      expect(page).to_not have_current_path(current_lectures_path)
    end
  end
end
