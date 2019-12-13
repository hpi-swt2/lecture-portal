require "rails_helper"

describe "The all lectures page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being signed in as a lecturer that created a lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @lecturer
    end

    it "should have a \"Start\" button for not started lecture" do
      visit(lectures_path)
      expect(page).to have_selector("input[type=submit][value='Start']")
    end

    it "should not have a \"View\" link for not started lecture" do
      visit(lectures_path)
      expect(page).to_not have_link("View", href: lecture_path(@lecture))
    end

    it "should have a \"Create Lecture\" button" do
      visit(lectures_path)
      expect(page).to have_link("Create Lecture")
    end

    it "should set the lecture active on clicking \"Start\"" do
        visit(lectures_path)
        click_on("Start")
        @lecture.reload
        expect(@lecture.status).to eq("running")
      end

    it "should redirect to the show path after clicking \"Start\"" do
      visit(lectures_path)
      click_on("Start")
      expect(current_path).to eq(lecture_path(@lecture))
    end

    it "should not show the \"Start\" button after a lecture was started" do
      visit(lectures_path)
      click_on("Start")
      expect(page).not_to have_selector("input[type=submit][value='Start']")
    end

    it "should show a \"View\" link after the lecture is started" do
      @lecture.update(status: "running")
      visit(lectures_path)
      expect(page).to have_link("View", href: lecture_path(@lecture))
    end

    it "should not show lectures of other lecturers" do
      @lecture2 = FactoryBot.create(:lecture)
      @lecture2.update(status: "running")
      visit(lectures_path)
      expect(page).to_not have_link("View", href: lecture_path(@lecture2))
    end
  end

  it "should redirect to current lectures page when accessed by a student" do
    @student = FactoryBot.create(:user, :student)
    sign_in @student
    visit(lectures_path)
    expect(page).to have_current_path(current_lectures_path)
  end

  
end
