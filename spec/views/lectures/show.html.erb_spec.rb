require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  description: "Test",
                                  enrollment_key: "Enrollment Key",
                                  status: "running",
                                  lecturer: FactoryBot.create(:user, :lecturer, email: "bp@hpi.de")
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

  describe "as a lecturer" do
    before(:each) do
      @current_user = @lecture.lecturer
      render
    end

    it "renders settings tab" do
      assert_select "a", "Settings"
      expect(rendered).to have_content("Settings")
      expect(rendered).to have_css("#settings-tab")
    end
    it "renders no edit button" do
      expect(rendered).to have_content("Edit")
    end
    it "renders end button" do
      expect(rendered).to have_css("[value='End Lecture']")
    end
    it "renders a leave lecture button" do
      expect(rendered).not_to have_css("[value='Leave Lecture']")
    end
  end

  describe "as a student" do
    before(:each) do
      @current_user = FactoryBot.create(:user, :student)
      @lecture.join_lecture(@current_user)
      render
    end
    it "renders no settings tab" do
      expect(rendered).not_to have_content("Settings")
      expect(rendered).not_to have_css("#settings-tab")
    end
    it "renders no edit button" do
      expect(rendered).not_to have_content("Edit")
    end
    it "renders no end button" do
      expect(rendered).not_to have_css("[value='End']")
    end
    it "renders a leave lecture button" do
      expect(rendered).to have_css("[value='Leave Lecture']")
    end
  end
end
