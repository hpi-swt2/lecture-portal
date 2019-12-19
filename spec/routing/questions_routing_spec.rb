require "rails_helper"

RSpec.describe QuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/questions").to route_to("questions#index")
    end
    it "routes to #create" do
      expect(post: "/questions").to route_to("questions#create")
    end
  end
end
