require "rails_helper"

RSpec.describe "Courses", type: :request do
  describe "GET /courses" do

    it "redirects when not logged in" do
      get courses_path
      expect(response).to have_http_status(302)
    end
  end
end
