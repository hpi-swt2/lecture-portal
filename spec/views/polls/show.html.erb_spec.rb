require "rails_helper"
require "capybara_table/rspec"

RSpec.describe "polls/show", type: :view do
  before(:each) do
    login_lecturer
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
    @poll_options = assign(:poll_options, [
      PollOption.create!(
        description: "abc",
        poll_id: @poll.id,
        votes: 2
      ),
      PollOption.create!(
        description: "def",
        poll_id: @poll.id,
        votes: 3
      )
     ])
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@poll.title)
    expect(rendered).to have_text("Multiselect disabled")
    expect(rendered).to have_text("Active")
  end

  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end
end
