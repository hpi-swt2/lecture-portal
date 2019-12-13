require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    @lectures = assign(:lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer, email: "hp@hpi.de")
      ),
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer, email: "cm@hpi.de")
      )
    ])
  end

  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Enrollment Key".to_s, count: 2
    assert_select "tr>td", text: "created".to_s, count: 2
  end

  it "renders Start button for created lectures" do
    render
    assert_select "[value='Start']", count: 2
  end

  it "renders View and End button for running lectures" do
    @lectures[0].status = "running"
    @lectures[1].status = "running"
    render
    assert_select "tr>td", text: "running".to_s, count: 2
    assert_select "a", "View"
    expect(rendered).to have_css("[value='End']")
  end

  it "renders Review button for ended lectures" do
    @lectures[0].status = "ended"
    @lectures[1].status = "ended"
    render
    assert_select "tr>td", text: "ended".to_s, count: 2
    assert_select "a", "Review"
  end
end
