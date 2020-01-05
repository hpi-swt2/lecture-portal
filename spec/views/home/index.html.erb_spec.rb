require "rails_helper"

RSpec.describe "home/index", type: :view do
  it "has a button to create a new course" do
    @current_user = FactoryBot.create(:user, :lecturer)
    sign_in @current_user
    visit root_path
    expect(page).to have_link "New Course", href: new_course_path
  end

  it "displays all open courses for a student" do
    FactoryBot.create(:course, name: "index_test")
    FactoryBot.create(:course, name: "index_test")
    @current_user = FactoryBot.create(:user, :student)
    sign_in @current_user
    visit root_path
    expect(page).to have_selector("td", text: "index_test", count: 2)
  end
end
