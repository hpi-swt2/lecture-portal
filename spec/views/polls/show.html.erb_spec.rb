require "rails_helper"

RSpec.describe "polls/show", type: :view do
  before(:each) do
  	login_lecturer
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/false/)
  end

  it "shows votes for the poll" do
 	visit lecture_poll_path(@lecture, @poll)
  	expect(page).to have_text('Votes')
  end
  
end
