require 'rails_helper'

RSpec.describe "Lectures", type: :request do
  describe "GET /lectures" do
    it "works! (now write some real specs)" do
      get lectures_path
      expect(response).to have_http_status(200)
    end
  end
end
