require "rails_helper"

RSpec.describe "lectures/edit", type: :view do
  before(:each) do
    @lecture = assign(:lecture, Lecture.create!(
                                  name: "MyString",
                                  enrollment_key: "MyString",
                                  status: "created"
    ))
  end

  it "renders the edit lecture form" do
    render

    assert_select "form[action=?][method=?]", lecture_path(@lecture), "post" do
      assert_select "input[name=?]", "lecture[name]"

      assert_select "input[name=?]", "lecture[enrollment_key]"

      assert_select "input[name=?]", "lecture[questions_enabled]"

      assert_select "input[name=?]", "lecture[polls_enabled]"
    end
  end

  it "renders a delete button" do
    render

    assert_select "[data-method=delete]"
  end
end
