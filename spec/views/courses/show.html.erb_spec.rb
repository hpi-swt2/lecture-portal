require "rails_helper"

RSpec.describe "courses/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer)
    @course = FactoryBot.create(:course, creator: @lecturer)
    @lecture = FactoryBot.create(:lecture, name: "Name", enrollment_key: "Enrollment", status: "created",  course: @course, lecturer: @lecturer, date: Date.tomorrow)
    @current_user = FactoryBot.create(:user, :lecturer)
    @student_files = []
    @lecturer_files = []
    sign_in @lecturer
  end

  it "renders title and description of the course " do
    render
    expect(rendered).to match(@course.name)
    expect(rendered).to match(@course.description)
  end

  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: @lecture.name, count: 1
    assert_select "tr>td", text: @lecture.enrollment_key, count: 1
    assert_select "tr>td", text: @lecture.status, count: 1
  end

  context "for students" do
    before(:each) do
      login_student
      @lecture.update(status: "running", date: Date.today, start_time: DateTime.now, end_time: DateTime.now + 20.minutes)
    end

    it "displays key input form for lectures with a key for not joined students" do
      render
      # it's 3 because of the hidden input fields in a form
      assert_select "form input", count: 3
      assert_select "form", count: 1
    end

    it "does not display key input form for lectures without a key for not joined students" do
      @lecture.update(enrollment_key: nil)
      render
      # it's 1 because of the Join button is a form
      assert_select "form input", count: 1
      assert_select "form", count: 1
    end
  end

  def login_student(user = FactoryBot.create(:user, :student))
    sign_in(user, scope: :user)
    @current_user = user
  end
end
