require "rails_helper"

RSpec.describe "polls/index", type: :view do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
    assign(:polls, [
      Poll.create!(
        title: "Title1",
        is_multiselect: false,
        lecture_id: @lecture.id
      ),
      Poll.create!(
        title: "Title2",
        is_multiselect: false,
        lecture_id: @lecture.id
      )
    ])
  end

  it "renders a list of polls" do
    visit lecture_polls_path(@lecture)
    expect(page).to have_text("Title1")
    expect(page).to have_text("Title2")
  end
end
