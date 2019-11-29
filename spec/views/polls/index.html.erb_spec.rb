require "rails_helper"

RSpec.describe "polls/index", type: :view do
  before(:each) do
    assign(:polls, [
      Poll.create!(
        title: "Title",
        is_multiselect: false
      ),
      Poll.create!(
        title: "Title",
        is_multiselect: false
      )
    ])
  end

  it "renders a list of polls" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
