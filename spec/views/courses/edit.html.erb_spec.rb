require "rails_helper"

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @course = FactoryBot.create(:course)
  end

  it "renders the edit course form" do
    render
    assert_select "form[action=?][method=?]", course_path(@course), "post" do
      assert_select "input[name=?]", "course[name]"
      assert_select "input[name=?]", "course[description]"
    end
  end

  it "renders a delete button" do
    render
    assert_select "[data-method=delete]"
  end
end
