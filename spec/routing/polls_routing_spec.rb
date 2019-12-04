require "rails_helper"

RSpec.describe PollsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "lectures/1/polls").to route_to("polls#index", lecture_id: "1")
    end

    it "routes to #new" do
      expect(get: "lectures/1/polls/new").to route_to("polls#new", lecture_id: "1")
    end

    it "routes to #show" do
      expect(get: "lectures/1/polls/1").to route_to("polls#show", id: "1", lecture_id: "1")
    end

    it "routes to #edit" do
      expect(get: "lectures/1/polls/1/edit").to route_to("polls#edit", id: "1", lecture_id: "1")
    end


    it "routes to #create" do
      expect(post: "lectures/1/polls").to route_to("polls#create", lecture_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "lectures/1/polls/1").to route_to("polls#update", id: "1", lecture_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "lectures/1/polls/1").to route_to("polls#update", id: "1", lecture_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "lectures/1/polls/1").to route_to("polls#destroy", id: "1", lecture_id: "1")
    end
  end
end
