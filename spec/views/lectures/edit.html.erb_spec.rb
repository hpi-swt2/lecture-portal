require "rails_helper"

RSpec.describe "lectures/edit", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "MyString",
                                  enrollment_key: "MyString",
                                  status: "created",
                                  lecturer: FactoryBot.create(:user, :lecturer),
                                  course: @course,
                                  date: "2020-02-02",
                                  start_time: "2020-01-01 10:10:00",
                                  end_time: "2020-01-01 10:20:00"
    ))
  end

  it "renders the edit lecture form" do
    render
    assert_select "form[action=?][method=?]", course_lecture_path(course_id: @course.id, id: @lecture), "post" do
      assert_select "input[name=?]", "lecture[name]"
      assert_select "input[name=?]", "lecture[enrollment_key]"
      # components of time_select and date_select
      assert_select "select[name=?]", "lecture[date(1i)]"
      assert_select "select[name=?]", "lecture[date(2i)]"
      assert_select "select[name=?]", "lecture[date(3i)]"
      # there are 3 hidden inputs for start and end time, so the selects start with 4i
      assert_select "select[name=?]", "lecture[start_time(4i)]"
      assert_select "select[name=?]", "lecture[start_time(5i)]"
      assert_select "select[name=?]", "lecture[end_time(4i)]"
      assert_select "select[name=?]", "lecture[end_time(5i)]"
      assert_select "input[name=?]", "lecture[questions_enabled]"
      assert_select "input[name=?]", "lecture[polls_enabled]"
      assert_select "input[name=?]", "lecture[feedback_enabled]"
    end
  end

  it " should be disabled if the lecture is archived" do
    @lecture.update(date: Date.yesterday)
    render
    assert_select "form[action=?][method=?]", course_lecture_path(course_id: @course.id, id: @lecture), "post" do
      assert_select "input[name=?][readonly]", "lecture[name]"
      assert_select "input[name=?][disabled]", "lecture[questions_enabled]"
      assert_select "input[name=?][disabled]", "lecture[polls_enabled]"
    end
  end

  it "should have a \"back\" button which redirects to the course overview." do
    render
    assert_select "[href =?]", course_path(id: @course.id)
  end

  it "renders a delete button" do
    render

    assert_select "[data-method=delete]"
  end
end

RSpec.describe "lectures/edit", type: :view do
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "MyString",
                                  enrollment_key: "MyString",
                                  status: "ended",
                                  lecturer: FactoryBot.create(:user, :lecturer, email: "123test@gmail.com")
    ))
  end
end
