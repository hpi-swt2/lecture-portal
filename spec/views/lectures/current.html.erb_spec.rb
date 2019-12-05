RSpec.describe "lectures/current", type: :view do
  before(:each) do
    @lecturer =FactoryBot.create(:user, :lecturer, email: "test@test.de")
    @lectures = assign(:lectures, [
      Lecture.create!(
        name: "running lecture",
        enrollment_key: "Enrollment Key",
        status: "running",
        lecturer: @lecturer
      ),
      Lecture.create!(
        name: "not running lecture",
        enrollment_key: "Enrollment Key",
        status: "created",
        lecturer: @lecturer
      )
    ])
  end

  it "renders a list of lectures" do
    render
    expect(rendered).to have_css("td", text: @lectures[0].name)
    expect(rendered).to have_css("td", text: @lectures[1].name)
  end
end
