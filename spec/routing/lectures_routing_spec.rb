require "rails_helper"

RSpec.describe LecturesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/courses/1/lectures").to route_to("lectures#index", course_id: "1")
    end

    it "routes to #new" do
      expect(get: "/courses/1/lectures/new").to route_to("lectures#new", course_id: "1")
    end

    it "routes to #show" do
      expect(get: "/courses/1/lectures/1").to route_to("lectures#show", id: "1", course_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/courses/1/lectures/1/edit").to route_to("lectures#edit", id: "1", course_id: "1")
    end


    it "routes to #create" do
      expect(post: "/courses/1/lectures").to route_to("lectures#create", course_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/courses/1/lectures/1").to route_to("lectures#update", id: "1", course_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/courses/1/lectures/1").to route_to("lectures#update", id: "1", course_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/courses/1/lectures/1").to route_to("lectures#destroy", id: "1", course_id: "1")
    end
  end
end
