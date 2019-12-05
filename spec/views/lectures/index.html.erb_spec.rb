require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    assign(:lectures, [
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
end
