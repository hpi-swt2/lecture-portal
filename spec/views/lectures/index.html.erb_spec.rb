require "rails_helper"

RSpec.describe "lectures/index", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    assign(:lectures, [
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer, email: "hp@hpi.de"),
        course: @course
      ),
      Lecture.create!(
        name: "Name",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: FactoryBot.create(:user, :lecturer, email: "cm@hpi.de"),
        course: @course
      )
    ])
  end

# this test is now in courses/show.html.erb_spec due that lectures don't have an own index anymore
=begin
  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Enrollment Key".to_s, count: 2
    assert_select "tr>td", text: "created".to_s, count: 2
  end
=end
end
