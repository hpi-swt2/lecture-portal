require "rails_helper"

RSpec.describe "courses/show", type: :view do
  let(:valid_session) { {} }
  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer)
    @course = FactoryBot.create(:course, creator: @lecturer)
    @lecture = FactoryBot.create(:lecture, name: "Name", enrollment_key: "Enrollment", status: "created",  course: @course, lecturer: @lecturer)
    @current_user = FactoryBot.create(:user, :lecturer)
    sign_in @lecturer
  end

  it "renders attributes of the course in <p>" do
    render
    expect(rendered).to match(/SWT2/)
    expect(rendered).to match(/ruby/)
    expect(rendered).to match(/open/)
  end

  it "renders a list of lectures" do
    render
    assert_select "tr>td", text: @lecture.name, count: 1
    assert_select "tr>td", text: @lecture.enrollment_key, count: 1
    assert_select "tr>td", text: @lecture.status, count: 1
  end

  it "should have a \"Start\" link for not started lecture" do
    visit(course_path(id: @lecture.course.id))

    expect(page).to have_link("Start", href: start_lecture_path(course_id: @lecture.course.id) + "?id=" + @lecture.id.to_s)
  end

  it "should not have a \"View\" link for not started lecture" do
    visit(course_path(id: @lecture.course.id))
    expect(page).to_not have_link("View", href: course_lecture_path(course_id: @lecture.course.id, id: @lecture.id))
  end

  it "should have a \"Create Lecture\" button" do
    visit(course_path(id: @lecture.course.id))
    expect(page).to have_link("Create Lecture")
  end

  it "should set the lecture active on clicking \"Start\"" do
    visit(course_path(id: @lecture.course.id))
    click_on("Start")
    @lecture.reload
    expect(@lecture.status).to eq("running")
  end

  it "should redirect to the show path after clicking \"Start\"" do
    visit(course_path(id: @lecture.course.id))
    click_on("Start")
    expect(current_path).to eq(course_lecture_path(course_id: @lecture.course.id, id: @lecture.id))
  end

  it "should not show the \"Start\" button after a lecture was started" do
    visit(course_path(id: @lecture.course.id))
    click_on("Start")
    expect(page).not_to have_selector("input[type=submit][value='Start']")
  end

  it "should show a \"View\" link after the lecture is started" do
    @lecture.update(status: "running")
    visit(course_path(id: @lecture.course.id))
    expect(page).to have_link("View", href: course_lecture_path(course_id: @lecture.course.id, id: @lecture.id))
  end

  it "should not show lectures of other lecturers" do
    @lecture2 = FactoryBot.create(:lecture)
    @lecture2.update(status: "running")
    visit(course_path(id: @lecture.course.id))
    expect(page).to_not have_link("View", href: course_lecture_path(course_id: @lecture2.course.id, id: @lecture2.id))
  end
end
