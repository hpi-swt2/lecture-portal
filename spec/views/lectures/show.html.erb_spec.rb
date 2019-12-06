require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  description: "Test",
                                  enrollment_key: "Enrollment Key",
                                  status: "created",
                                  lecturer: FactoryBot.create(:user, :lecturer, email: "bp@hpi.de")
    ))
   # @student = FactoryBot.create(:user, :student)

  end

  it "renders navbar tabs without settings for student" do
    @current_user = FactoryBot.create(:user, :student)
    render
    assert_select "a", "Dashboard"
    assert_select "a", "Feedback"
    assert_select "a", "Questions"
    assert_select "a", "Polls"
  end

  it "renders navbar tabs with settings for lecturer" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Dashboard"
    assert_select "a", "Feedback"
    assert_select "a", "Questions"
    assert_select "a", "Polls"
    assert_select "a", "Settings"
  end

end
