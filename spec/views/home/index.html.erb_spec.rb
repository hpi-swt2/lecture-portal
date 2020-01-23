require "rails_helper"

RSpec.describe "home/index", type: :view do
  let(:valid_session) { {} }
  it "has a button to create a new course" do
    @current_user = FactoryBot.create(:user, :lecturer)
    sign_in @current_user
    visit root_path
    expect(page).to have_link "New Course", href: new_course_path
  end

  it "displays all open courses for a student" do
    # Using hard coded string and not factory default name cause a unique name is needed for this test
    FactoryBot.create(:course, name: "index_test")
    FactoryBot.create(:course, name: "index_test")
    @current_user = FactoryBot.create(:user, :student)
    sign_in @current_user
    visit root_path
    expect(page).to have_selector("td", text: "index_test", count: 2)
  end

  it "displays the courses that a student is enrolled in with link" do
    @course = FactoryBot.create(:course)
    @current_user = FactoryBot.create(:user, :student)
    @course.join_course(@current_user)
    sign_in @current_user
    visit root_path
    expect(page).to have_button("View")
  end

  it "has link to the user profile" do
    @current_user = FactoryBot.create(:user, :student)
    sign_in @current_user
    visit root_path
    expect(page).to have_link("Show Profile", href: users_show_path)
  end


  context "for students" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @lecture = FactoryBot.create(:lecture, name: "Name", enrollment_key: "Enrollment", status: "created",  course: @course, lecturer: @lecturer)
      login_student
      @course.join_course(@current_user)
      @lecture.update(status: "running")
    end

    it "displays key input form for lectures with a key for not joined students" do
      visit root_path
      save_and_open_page
      expect(page).to have_text("Join")
      # it's 2 because of the courses button
      expect(page).to have_css("form", count: 2)
      # it's 3 because of the courses button and the hidden field in the key input form
      expect(page).to have_css("input", count: 3)
    end

    it "does not display key input form for lectures without a key for not joined students" do
      @lecture.update(enrollment_key: nil)
      visit root_path
      save_and_open_page
      expect(page).to have_text("Join")
      # it's 2 because of the courses button
      expect(page).to have_css("form", count: 2)
      # it's 2 because of the courses button
      expect(page).to have_css("input", count: 2)
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
    @current_user = user
  end
end
