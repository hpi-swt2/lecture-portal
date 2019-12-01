require "rails_helper"

RSpec.describe "Polls", type: :request do
  describe "GET /polls" do
    it "works! (now write some real specs)" do
      get polls_path
      expect(response).to have_http_status(200)
    end
  end
end
