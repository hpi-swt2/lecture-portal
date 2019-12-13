require "rails_helper"

RSpec.describe "lectures/new", type: :view do
  before(:each) do
    assign(:lecture, Lecture.new(
                       name: "MyString",
                       enrollment_key: "MyString",
                       status: "created"
    ))
  end

  it "renders new lecture form" do
    render

    assert_select "form[action=?][method=?]", lectures_path, "post" do
      assert_select "input[name=?]", "lecture[name]"

      assert_select "input[name=?]", "lecture[enrollment_key]"

      assert_select "input[name=?]", "lecture[questions_enabled]"

      assert_select "input[name=?]", "lecture[polls_enabled]"

      assert_select "input[name=?]", "lecture[description]"
    end
  end
end
