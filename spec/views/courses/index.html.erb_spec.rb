require "rails_helper"

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      FactoryBot.create(:course),
      FactoryBot.create(:course)
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", text: "SWT2".to_s, count: 2
    assert_select "tr>td", text: "ruby".to_s, count: 2
    assert_select "tr>td", text: "open".to_s, count: 2
  end
end
