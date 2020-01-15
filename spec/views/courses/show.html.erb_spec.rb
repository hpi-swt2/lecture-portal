require "rails_helper"

RSpec.describe "courses/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer)
    @course = FactoryBot.create(:course, creator: @lecturer)
    @lecture = FactoryBot.create(:lecture, name: "Name", enrollment_key: "Enrollment", status: "created",  course: @course, lecturer: @lecturer)
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
end
