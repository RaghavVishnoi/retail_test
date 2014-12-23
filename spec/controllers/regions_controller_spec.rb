require 'rails_helper'

describe RegionsController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @region = mock_model(Region, :update_attributes => true)
    Region.stub(:where).and_return([@region])
  end

  shared_examples_for "request which sets region" do
    it "finds region" do
      expect(Region).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @region" do
      send_request
      expect(assigns(:region)).to eq(@region)
    end

    context "when region not found" do
      before do
        Region.stub(:where).and_return([])
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(regions_url)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Region not found")
      end
    end
  end

  describe "GET index" do
    before do
      @regions = double("regions")
      Region.stub(:all).and_return(@regions)
    end

    def send_request
      get :index
    end

    it "finds all regions" do
      expect(Region).to receive(:all)
      send_request
    end

    it "sets @regions" do
      send_request
      expect(assigns(:regions)).to eq(@regions)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @region = mock_model(Region)
      Region.stub(:new).and_return(@region)
    end

    def send_request
      get :new
    end

    it "initializes new region" do
      expect(Region).to receive(:new)
      send_request
    end

    it "sets @region" do
      send_request
      expect(assigns(:region)).to eq(@region)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @region = mock_model(Region, :save => true)
      Region.stub(:new).and_return(@region)
    end

    def send_request
      post :create, :region => region_params
    end

    def region_params
      { 'name' => 'region_name' }
    end

    it "initializes new region" do
      expect(Region).to receive(:new).with(region_params)
      send_request
    end

    it "sets @region" do
      send_request
      expect(assigns(:region)).to eq(@region)
    end

    it "saves" do
      expect(@region).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(regions_url)
      end
    end

    context "when not saved successfully" do
      before do
        @region.stub(:save).and_return(false)
      end

      it "renders new template" do
        send_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do

    def send_request
      get :edit, :id => 'id'
    end

    it_behaves_like "request which sets region"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :region => region_params
    end

    def region_params
      { 'name' => 'region name' }
    end

    it_behaves_like "request which sets region"

    it "updates region" do
      expect(@region).to receive(:update_attributes).with(region_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(regions_url)
      end
    end

    context "when not updated successfully" do
      before do
        @region.stub(:update_attributes).and_return(false)
      end

      it "renders edit page" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do

    def send_request
      delete :destroy, :id => 'id'
    end

    it_behaves_like "request which sets region"

    it "destroys region" do
      expect(@region).to receive(:destroy)
      send_request
    end

    it "redirects to regions_url" do
      send_request
      expect(response).to redirect_to(regions_url)
    end
  end
end