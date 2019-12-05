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
