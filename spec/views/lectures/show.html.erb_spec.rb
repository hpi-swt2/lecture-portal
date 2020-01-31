require "rails_helper"
RSpec.describe "lectures/show", type: :view do
  include Devise::TestHelpers
  let(:valid_session) { {} }
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "Name",
                                  enrollment_key: "Enrollment Key",
                                  status: "running",
                                  lecturer: FactoryBot.create(:user, :lecturer),
                                  course: @course,
                                  date: Date.today,
                                  start_time: DateTime.now,
                                  end_time: DateTime.now + 20.minutes
    ))
  end

  describe "as a lecturer" do
    before(:each) do
      @current_user = @lecture.lecturer
      sign_in @lecture.lecturer
    end

    it "renders navbar tabs" do
      render
      assert_select "a", "Dashboard"
      assert_select "a", "Feedback"
      assert_select "a", "Questions"
      assert_select "a", "Polls"
      assert_select "a", "Settings"
      expect(rendered).to have_css("#dashboard-tab")
      expect(rendered).to have_css("#feedback-tab")
      expect(rendered).to have_css("#questions-tab")
      expect(rendered).to have_css("#polls-tab")
      expect(rendered).to have_css("#settings-tab")
    end

    it "renders enrollment key tab if enrollment key is present" do
      render
      assert_select "a", "Enrollment Key"
      expect(rendered).to have_content("Enrollment Key")
      expect(rendered).to have_css("#enrollmentKey-tab")
    end

    it "renders enrollment qr code if enrollment key is present" do
      @qr_code = RQRCode::QRCode.new("http://some-random.url/that/is/not/tested")
      render
      assert_select "a", "Enrollment Key"
      expect(rendered).to have_selector("div", class: "qr-code-container")
    end

    it "does not render enrollment key tab button if enrollment key is not present" do
      @lecture.update(enrollment_key: nil)
      render
      expect(rendered).not_to have_css("#enrollmentKey-tab")
    end

    it "renders a leave lecture button" do
      render
      expect(rendered).not_to have_css("[value='Leave Lecture']")
    end

    it "shows notice page on polls tab when polls are disabled" do
      @lecture.update(polls_enabled: false)
      render
      expect(rendered).to have_text("Polls are not enabled.")
    end

    it "shows notice page on questions tab when questions are disabled" do
      @lecture.update(questions_enabled: false)
      render
      assert_select "a", "Questions"
      expect(rendered).to have_text("Questions are not enabled.")
    end

    it "shows notice page on feedback tab when feedback is disabled" do
      @lecture.update(feedback_enabled: false)
      render
      assert_select "a", "Feedback"
      expect(rendered).to have_text("Feedback is not enabled or the lecture is not active.")
    end

    it "does not show notice pages on disabled questions/polls/feedback when questions are enabled" do
      render
      expect(rendered).to_not have_text("Questions are not enabled.")
      expect(rendered).to_not have_text("Polls are not enabled.")
      expect(rendered).to_not have_text("Feedback is not enabled.")
    end

    it "shows list of participating students in enrollment key tab" do
      @lecture.join_lecture(FactoryBot.create(:user, :student, email: "student@mail.com"))
      render
      assert_select "a", "Enrollment Key"
      expect(rendered).to have_text("student@mail.com")
    end

    it "can change title in settings tab" do
      render
      assert_select "a", "Settings"
      expect(rendered).to have_selector("input[id='lecture_name'][type='text']")
    end

    it "can change enrollment key in settings tab" do
      render
      assert_select "a", "Settings"
      expect(rendered).to have_selector("input[id='lecture_enrollment_key'][type='text']")
    end

    it "can change polls in settings tab" do
        render
        assert_select "a", "Settings"
        expect(rendered).to have_selector("input[id='lecture_polls_enabled'][type='checkbox']")
      end

    it "can change questions in settings tab" do
      render
      assert_select "a", "Settings"
      expect(rendered).to have_selector("input[id='lecture_questions_enabled'][type='checkbox']")
    end
  end

  describe "as a student" do
    before(:each) do
      @current_user = FactoryBot.create(:user, :student)
      sign_in @current_user
      @lecture.join_lecture(@current_user)
    end

    it "renders navbar tabs" do
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

    it "renders no enrollment key tab" do
      render
      expect(rendered).not_to have_content("Enrollment Key")
      expect(rendered).not_to have_css("#enrollmentKey-tab")
    end

    it "renders no settings tab" do
      render
      expect(rendered).not_to have_content("Settings")
      expect(rendered).not_to have_css("#settings-tab")
    end

    it "renders no end button" do
      render
      expect(rendered).not_to have_css("[value='End']")
    end

    it "renders a leave lecture button" do
      render
      expect(rendered).to have_link("Leave Lecture")
    end
  end
end
