require "rails_helper"

RSpec.describe "home/index", type: :view do

  it "has a button to create a new course" do
    visit root_path
    expect(page).to have_link 'New Course', href: new_course_path
  end
end
