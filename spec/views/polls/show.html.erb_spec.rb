require "rails_helper"

RSpec.describe "polls/show", type: :view do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/false/)
  end
end
