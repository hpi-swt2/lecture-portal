require "rails_helper"

RSpec.describe "lectures/edit", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "MyString",
                                  enrollment_key: "MyString",
                                  status: "created",
                                  lecturer: FactoryBot.create(:user, :lecturer),
                                  course: @course
    ))
  end

  it "renders the edit lecture form" do
    render

    assert_select "form[action=?][method=?]", course_lecture_path(course_id: @course.id, id: @lecture), "post" do
      assert_select "input[name=?]", "lecture[name]"

      assert_select "input[name=?]", "lecture[enrollment_key]"

      assert_select "input[name=?]", "lecture[questions_enabled]"

      assert_select "input[name=?]", "lecture[polls_enabled]"

      assert_select "input[name=?]", "lecture[description]"
    end
  end

  it " should be disabled if the lecture is archived" do
    @lecture.set_inactive
    render
    assert_select "form[action=?][method=?]", course_lecture_path(course_id: @course.id, id: @lecture), "post" do
      assert_select "input[name=?][readonly]", "lecture[name]"

      assert_select "input[name=?][readonly]", "lecture[description]"

      assert_select "input[name=?][disabled]", "lecture[questions_enabled]"

      assert_select "input[name=?][disabled]", "lecture[polls_enabled]"
    end
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
