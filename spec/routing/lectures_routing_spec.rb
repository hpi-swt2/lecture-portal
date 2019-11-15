require "rails_helper"

RSpec.describe LecturesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/lectures").to route_to("lectures#index")
    end

    it "routes to #new" do
      expect(:get => "/lectures/new").to route_to("lectures#new")
    end

    it "routes to #show" do
      expect(:get => "/lectures/1").to route_to("lectures#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lectures/1/edit").to route_to("lectures#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/lectures").to route_to("lectures#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lectures/1").to route_to("lectures#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lectures/1").to route_to("lectures#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lectures/1").to route_to("lectures#destroy", :id => "1")
    end
  end
end
