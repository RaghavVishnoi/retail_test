require "rails_helper"

RSpec.describe TatGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tat_groups").to route_to("tat_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/tat_groups/new").to route_to("tat_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/tat_groups/1").to route_to("tat_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tat_groups/1/edit").to route_to("tat_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tat_groups").to route_to("tat_groups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tat_groups/1").to route_to("tat_groups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tat_groups/1").to route_to("tat_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tat_groups/1").to route_to("tat_groups#destroy", :id => "1")
    end

  end
end
