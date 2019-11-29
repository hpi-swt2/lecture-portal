require "rails_helper"

RSpec.describe QuestionsApiController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/questions").to route_to("questions_api#index")
    end

    it "routes to #create" do
      expect(:post => "/api/questions").to route_to("questions_api#create")
    end
  end
end
