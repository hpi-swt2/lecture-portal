require "rails_helper"

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new(
                      name: "MyString",
                      description: "MyText",
    ))
  end

  it "renders new course form" do
    render
    assert_select "form[action=?][method=?]", courses_path, "post" do
      assert_select "input[name=?]", "course[name]"
      assert_select "input[name=?]", "course[description]"
    end
  end

  it "should have a \"back\" button which redirects to the home page" do
    render
    assert_select "[href =?]", root_path
  end
end
