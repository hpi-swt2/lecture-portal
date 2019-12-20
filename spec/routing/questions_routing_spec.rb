require "rails_helper"

RSpec.describe QuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "lectures/1/questions").to route_to("questions#index", lecture_id: "1")
    end
    it "routes to #create" do
      expect(post: "lectures/1/questions").to route_to("questions#create", lecture_id: "1")
    end
    it "routes to #resolve" do
      expect(post: "lectures/1/questions/1/resolve").to route_to("questions#resolve", lecture_id: "1", id: "1")
    end
    it "routes to #upvote" do
      expect(post: "lectures/1/questions/1/upvote").to route_to("questions#upvote", lecture_id: "1", id: "1")
    end
  end
end
