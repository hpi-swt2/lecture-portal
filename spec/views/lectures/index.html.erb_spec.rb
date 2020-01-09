require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    assign(:created_lectures, [])
    assign(:running_lectures, [])
    assign(:ended_lectures, [])
  end

  it "renders a list of lectures" do
    lectures = assign(:created_lectures, FactoryBot.create_list(:lecture, 3, status: "created"))
    render
    for lecture in lectures do
      assert_select "tr>td", text: lecture.name
      assert_select "tr>td", text: lecture.enrollment_key
    end
  end

  it "renders Start button for created lectures" do
    assign(:created_lectures, [
      FactoryBot.create(:lecture, status: "created")
    ])
    render
    assert_select "[value='Start']", count: 1
  end

  it "renders View and End button for running lectures" do
    assign(:running_lectures, [
      FactoryBot.create(:lecture, status: "running")
    ])
    render
    assert_select "[value='End']", count: 1
    assert_select "a", "View"
    expect(rendered).to have_css("[value='End']")
  end

  it "renders Review button for ended lectures" do
    assign(:ended_lectures, [
      FactoryBot.create(:lecture, status: "ended")
    ])
    render
    assert_select "a", "Review"
  end
end
