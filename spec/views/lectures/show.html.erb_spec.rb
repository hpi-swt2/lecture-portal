require "rails_helper"

RSpec.describe "lectures/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  description: "Test",
                                  enrollment_key: "Enrollment Key",
                                  status: "running",
                                  lecturer: FactoryBot.create(:user, :lecturer),
                                  course: @course,
                                  date: "2020-02-02",
                                  start_time: "2020-01-01 10:10:00",
                                  end_time: "2020-01-01 10:20:00"
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
    it "renders end button" do
      expect(rendered).to have_link("End Lecture")
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
    it "renders no end button" do
      expect(rendered).not_to have_css("[value='End']")
    end
    it "renders a leave lecture button" do
      expect(rendered).to have_link("Leave Lecture")
    end
  end

  it "can change title in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("input[id='lecture_name'][type='text']")
  end
  it "can change description in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("textarea[id='lecture_description']")
  end

  it "can change enrollment key in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to_not have_selector("input[id='lecture_enrollment_key'][type='text']")
  end
  it "can change polls in settings tab" do
      @current_user = FactoryBot.create(:user, :lecturer)
      render
      assert_select "a", "Settings"
      expect(rendered).to have_selector("input[id='lecture_polls_enabled'][type='checkbox']")
    end

  it "can change questions in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("input[id='lecture_questions_enabled'][type='checkbox']")
  end

  it "can change title in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("input[id='lecture_name'][type='text']")
  end
  it "can change description in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("textarea[id='lecture_description']")
  end
  it "can not change enrollment_key in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to_not have_selector("input[id='lecture_enrollment_key'][type='text']")
  end
  it "can change polls in settings tab" do
      @current_user = FactoryBot.create(:user, :lecturer)
      render
      assert_select "a", "Settings"
      expect(rendered).to have_selector("input[id='lecture_polls_enabled'][type='checkbox']")
    end
  it "can change questions in settings tab" do
    @current_user = FactoryBot.create(:user, :lecturer)
    render
    assert_select "a", "Settings"
    expect(rendered).to have_selector("input[id='lecture_questions_enabled'][type='checkbox']")
  end
end
