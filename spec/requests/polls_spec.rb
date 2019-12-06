require "rails_helper"

RSpec.describe "Polls", type: :request do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
  end

  describe "GET /polls" do
    it "redirects when not logged in" do
      get lecture_polls_path(@lecture)
      expect(response).to have_http_status(302)
    end
  end
end
