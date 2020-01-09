require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    assign(:created_lectures, [])
    assign(:running_lectures, [])
    assign(:ended_lectures, [])
  end

  it "renders a list of lectures" do
    skip("Needs to be moved to course_show")
    lectures = assign(:created_lectures, FactoryBot.create_list(:lecture, 3, status: "created"))
    render
    for lecture in lectures do
      assert_select "tr>td", text: lecture.name
      assert_select "tr>td", text: lecture.enrollment_key
    end
  end

  it "renders Start button for created lectures" do
    skip("Needs to be moved to course_show")
    assign(:created_lectures, [
      FactoryBot.create(:lecture, status: "created")
    ])
    render
    assert_select "[value='Start']", count: 1

  end

  it "renders View and End button for running lectures" do
    skip("Needs to be moved to course_show")
    assign(:running_lectures, [
      FactoryBot.create(:lecture, status: "running")
    ])
    render
    assert_select "[value='End']", count: 1
    assert_select "a", "View"
    expect(rendered).to have_css("[value='End']")
    skip("Needs to be moved to course_show")
  end

  it "renders Review button for ended lectures" do
    skip("Needs to be moved to course_show")
    assign(:ended_lectures, [
      FactoryBot.create(:lecture, status: "ended")
    ])
    render
    assert_select "a", "Review"
    skip("Needs to be moved to course_show")
  end
end
