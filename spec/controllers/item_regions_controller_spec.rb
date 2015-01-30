require 'rails_helper'

describe ItemRegionsController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @item_region = mock_model(ItemRegion, :update_attributes => true, :destroy => true)
    ItemRegion.stub(:where).and_return([@item_region])
  end

  shared_examples_for "request which sets item_region" do
    it "finds item_region" do
      expect(ItemRegion).to receive(:where).with(:id => "id")
      send_request
    end

    it "sets @item_region" do
      send_request
      expect(assigns(:item_region)).to eq(@item_region)
    end

    context "when item_region not found" do
      before do
        ItemRegion.stub(:where).and_return([])
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("Item Region not found")
      end

      it "redirects to item_regions index" do
        send_request
        expect(response).to redirect_to(item_regions_path)
      end
    end
  end

  describe "GET index" do
    before do
      @item_regions = double("item_regions")
      ItemRegion.stub(:paginate).and_return(@item_regions)
    end

    def send_request
      get :index
    end

    it "paginates item_regions" do
      expect(ItemRegion).to receive(:paginate)
      send_request
    end

    it "sets @item_regions" do
      send_request
      expect(assigns(:item_regions)).to eq(@item_regions)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @item_region = mock_model(ItemRegion)
      ItemRegion.stub(:new).and_return(@item_region)
    end

    def send_request
      get :new
    end

    it "initializes item_region" do
      expect(ItemRegion).to receive(:new)
      send_request
    end

    it "sets @item_region" do
      send_request
      expect(assigns(:item_region)).to eq(@item_region)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @item_region = mock_model(ItemRegion, :save => true)
      ItemRegion.stub(:new).and_return(@item_region)
    end

    def send_request
      post :create, :item_region => item_region_params
    end

    def item_region_params
      { "name" => "item_region_name" }
    end

    it "initializes item_region" do
      expect(ItemRegion).to receive(:new).with(item_region_params)
      send_request
    end

    it "sets item_region" do
      send_request
      expect(assigns(:item_region)).to eq(@item_region)
    end

    it "saves item_region" do
      expect(@item_region).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "returns to item_regions_path" do
        send_request
        expect(response).to redirect_to(item_regions_path)
      end
    end

    context "when not saved successfully" do
      before do
        @item_region.stub(:save).and_return(false)
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

    it_behaves_like "request which sets item_region"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    def send_request
      put :update, :id => 'id', :item_region => item_region_params
    end

    def item_region_params
      { "name" => "item_region_name" }
    end

    it_behaves_like "request which sets item_region"

    it "updates attributes" do
      expect(@item_region).to receive(:update_attributes).with(item_region_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to item_regions index" do
        send_request
        expect(response).to redirect_to(item_regions_path)
      end
    end

    context "when not updated successfully" do
      before do
        @item_region.stub(:update_attributes).and_return(false)
      end

      it "renders edit template" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    def send_request
      delete :destroy, :id => 'id'
    end

    it_behaves_like "request which sets item_region"

    it "destroys item_region" do
      expect(@item_region).to receive(:destroy)
      send_request
    end

    context "when item_region deleted successfully" do
      it "redirects to item_regions index" do
        send_request
        expect(response).to redirect_to(item_regions_path)
      end
    end

    context "when item_region not deleted successfully" do
      before do
        @item_region.stub(:destroy).and_return(false)
        @item_region.errors[:base] << "error"
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("error")
      end

      it "redirects to item_regions index" do
        send_request
        expect(response).to redirect_to(item_regions_path)
      end
    end
  end
end