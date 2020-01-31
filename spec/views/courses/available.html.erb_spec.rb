require "rails_helper"

RSpec.describe "home/available", type: :view do
  let(:valid_session) { {} }



  context "for students" do
    before(:each) do
      @course = FactoryBot.create(:course)
      login_student
    end

    it "displays all open courses for a student" do
      # Using hard coded string and not factory default name cause a unique name is needed for this test
      FactoryBot.create(:course, name: "index_test_student")
      FactoryBot.create(:course, name: "index_test_student")
      visit available_courses_path
      expect(page).to have_selector("td", text: "index_test_student", count: 2)
    end

    it "displays a course's description" do
      @course = FactoryBot.create(:course)
      visit available_courses_path
      expect(page).to have_text(@course.description)
    end
  end


  context "for lecturer" do
    before(:each) do
      @course = FactoryBot.create(:course)
      login_lecturer
    end

    it "displays all open courses for a lecturer" do
      # Using hard coded string and not factory default name cause a unique name is needed for this test
      FactoryBot.create(:course, name: "index_test_lecturer")
      FactoryBot.create(:course, name: "index_test_lecturer")
      visit available_courses_path
      expect(page).to have_selector("td", text: "index_test_lecturer", count: 2)
    end

    it "displays a course's description" do
      @course = FactoryBot.create(:course)
      visit available_courses_path
      expect(page).to have_text(@course.description)
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
    @current_user = user
  end

  def login_lecturer(user = FactoryBot.create(:user, :lecturer))
    sign_in(user, scope: :user)
    @current_user = user
  end
end
