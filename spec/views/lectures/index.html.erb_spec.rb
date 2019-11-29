require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    assign(:lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        is_running: false
      ),
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        is_running: false
      )
    ])
  end

  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
