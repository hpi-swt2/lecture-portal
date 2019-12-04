RSpec.describe "lectures/current", type: :view do
  before(:each) do
    @lectures = assign(:lectures, [
      Lecture.create!(
        name: "running lecture",
        enrollment_key: "Enrollment Key",
        status: "running"
      ),
      Lecture.create!(
        name: "not running lecture",
        enrollment_key: "Enrollment Key",
        status: "created"
      )
    ])
  end

  it "renders a list of lectures" do
    render
    expect(rendered).to have_css("td", text: @lectures[0].name)
    expect(rendered).to have_css("td", text: @lectures[1].name)
  end
end
