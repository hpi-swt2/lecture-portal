require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    assign(:created_lectures, [])
    assign(:running_lectures, [])
    assign(:ended_lectures, [])
  end

  it "renders a list of lectures" do
    assign(:created_lectures, [
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
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Enrollment Key".to_s, count: 2
  end

  it "renders Start button for created lectures" do
    assign(:created_lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer, email: "hp@hpi.de")
      ),
    ])
    render
    assert_select "[value='Start']", count: 1
  end

  it "renders View and End button for running lectures" do
    assign(:running_lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "running",
        lecturer: FactoryBot.create(:user, :lecturer, email: "hp@hpi.de")
      ),
    ])
    render
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
