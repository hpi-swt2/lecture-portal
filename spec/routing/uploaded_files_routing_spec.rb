require "rails_helper"

RSpec.describe UploadedFilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/uploaded_files").to route_to("uploaded_files#index")
    end

    it "routes to #new" do
      expect(get: "/uploaded_files/new").to route_to("uploaded_files#new")
    end

    it "routes to #show" do
      skip("Deleted because not part of current story")
      expect(get: "/uploaded_files/1").to route_to("uploaded_files#show", id: "1")
    end

    it "routes to #edit" do
      skip("Deleted because not part of current story")
      expect(get: "/uploaded_files/1/edit").to route_to("uploaded_files#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/uploaded_files").to route_to("uploaded_files#create")
    end

    it "routes to #update via PUT" do
      skip("Deleted because not part of current story")
      expect(put: "/uploaded_files/1").to route_to("uploaded_files#update", id: "1")
    end

    it "routes to #update via PATCH" do
      skip("Deleted because not part of current story")
      expect(patch: "/uploaded_files/1").to route_to("uploaded_files#update", id: "1")
    end

    it "routes to #destroy" do
      skip("Deleted because not part of current story")
      expect(delete: "/uploaded_files/1").to route_to("uploaded_files#destroy", id: "1")
    end
  end
end
