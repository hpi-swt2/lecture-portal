require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  description: "Test",
                                  enrollment_key: "Enrollment Key",
                                  status: "created",
                                  lecturer: FactoryBot.create(:user, :lecturer, email: "bp@hpi.de"),
                                  course: @course
    ))
  end

  it "renders navbar tabs" do
    @current_user = FactoryBot.create(:user, :student)
    render
    assert_select "a", "Dashboard"
    assert_select "a", "Feedback"
    assert_select "a", "Questions"
    assert_select "a", "Polls"
    expect(rendered).to have_css("#dashboard-tab")
    expect(rendered).to have_css("#feedback-tab")
    expect(rendered).to have_css("#questions-tab")
    expect(rendered).to have_css("#polls-tab")
  end

  it "renders settings tab for lecturer" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_content("Settings")
    expect(rendered).to have_css("#settings-tab")
  end

  it "renders no settings tab for student" do
    @current_user = FactoryBot.create(:user, :student)
    render
    expect(rendered).not_to have_content("Settings")
    expect(rendered).not_to have_css("#settings-tab")
  end
end
