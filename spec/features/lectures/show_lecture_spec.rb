require "rails_helper"

describe "The show lecture page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  describe "as a lecturer" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @lecturer
    end

    it "should have no end button if the lecture is not running" do
      visit(lecture_path(@lecture))
      expect(page).not_to have_selector("input[type=submit][value='End']")
    end


    it "should have an end button if the lecture is running" do
      @lecture.update(status: "running")
      visit(lecture_path(@lecture))
      expect(page).to have_selector("input[type=submit][value='End']")
    end

    it "should end the lecture if the end button is clicked" do
      @lecture.update(status: "running")
      visit(lecture_path(@lecture))
      click_on("End")
      @lecture.reload
      expect(@lecture.status).to eq("ended")
    end

    it "should not be accesible by another lecturer" do
      @lecture2 = FactoryBot.create(:lecture)
      visit(lecture_path(@lecture2))
      expect(page).to_not have_current_path(lecture_path(@lecture2))
    end
  end

  describe "as a student" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @student = FactoryBot.create(:user, :student)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @student
    end

    it "students should be able to leave a lecture" do
      @lecture.update(status: "running")
      @lecture.join_lecture(@student)
      visit(lecture_path(@lecture))
      expect(@lecture.participating_students.length).to be 1
      expect(@lecture.participating_students[0]).to eq @student
      @lecture.reload
      click_on("Leave Lecture")
      @lecture.reload
      expect(@lecture.participating_students.length).to be 0
    end
  end
end
