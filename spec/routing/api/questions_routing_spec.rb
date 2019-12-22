require "rails_helper"

RSpec.describe Api::QuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/questions").to route_to("api/questions#index")
    end

    it "routes to #create" do
      expect(post: "/api/questions").to route_to("api/questions#create")
    end
  end
end
