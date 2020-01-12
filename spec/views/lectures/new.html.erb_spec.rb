require "rails_helper"

RSpec.describe "lectures/new", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
    @lecture = FactoryBot.create(:lecture, course: @course)
  end

  it "renders new lecture form" do
    render

    assert_select "form[action=?][method=?]",  course_lecture_path(course_id: @course.id, id: @lecture.id), "post" do
      assert_select "input[name=?]", "lecture[name]"

      assert_select "input[name=?]", "lecture[enrollment_key]"

      assert_select "input[name=?]", "lecture[questions_enabled]"

      assert_select "input[name=?]", "lecture[polls_enabled]"

      assert_select "input[name=?]", "lecture[description]"
    end
  end
end
