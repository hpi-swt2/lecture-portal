require "rails_helper"

RSpec.describe "polls/edit", type: :view do
  before(:each) do
    @poll = assign(:poll, Poll.create!(
                            title: "MyString",
                            is_multiselect: false,
      # lecture: FactoryBot.build(:lecture)
    ))
  end

  it "renders the edit poll form" do
    render

    assert_select "form[action=?][method=?]", poll_path(@poll), "post" do
      assert_select "input[name=?]", "poll[title]"

      assert_select "input[name=?]", "poll[is_multiselect]"
    end
  end
end
