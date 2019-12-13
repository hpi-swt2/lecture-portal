require "rails_helper"

RSpec.describe "polls/edit", type: :view do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
  end

  it "renders the edit poll form" do
    render

    assert_select "form[action=?][method=?]", lecture_poll_path(@lecture, @poll), "post" do
      assert_select "input[name=?]", "poll[title]"

      assert_select "input[name=?]", "poll[is_multiselect]"
    end
  end
end
