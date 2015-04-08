require 'rails_helper'

describe ItemsController do
  before do
    initialize_current_user
    @item = mock_model(Item, :update_attributes => true)
    Item.stub(:where).and_return([@item])
  end

  shared_examples_for "request which sets item" do
    it "finds item" do
      expect(Item).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @item" do
      send_request
      expect(assigns(:item)).to eq(@item)
    end

    context "when item not found" do
      before do
        Item.stub(:where).and_return([])
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(items_path)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Item not found")
      end
    end
  end

  describe "GET index" do
    before do
      @items = double("items")
      Item.stub(:paginate).and_return(@items)
    end

    def send_request
      get :index
    end

    it "paginates items" do
      expect(Item).to receive(:paginate)
      send_request
    end

    it "sets @items" do
      send_request
      expect(assigns(:items)).to eq(@items)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @item = mock_model(Item)
      Item.stub(:new).and_return(@item)
    end

    def send_request
      get :new
    end

    it "initializes new item" do
      expect(Item).to receive(:new)
      send_request
    end

    it "sets @item" do
      send_request
      expect(assigns(:item)).to eq(@item)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @item = mock_model(Item, :save => true)
      Item.stub(:new).and_return(@item)
    end

    def send_request
      post :create, :item => item_params
    end

    def item_params
      { 'name' => 'item_name' }
    end

    it "initializes new item" do
      expect(Item).to receive(:new).with(item_params)
      send_request
    end

    it "sets @item" do
      send_request
      expect(assigns(:item)).to eq(@item)
    end

    it "saves" do
      expect(@item).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(items_path)
      end
    end

    context "when not saved successfully" do
      before do
        @item.stub(:save).and_return(false)
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

    it_behaves_like "request which sets item"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :item => item_params
    end

    def item_params
      { 'name' => 'item_name' }
    end

    it_behaves_like "request which sets item"

    it "updates item" do
      expect(@item).to receive(:update_attributes).with(item_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(items_url)
      end
    end

    context "when not updated successfully" do
      before do
        @item.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets item"

    it "destroys item" do
      expect(@item).to receive(:destroy)
      send_request
    end

    it "redirects to items_path" do
      send_request
      expect(response).to redirect_to(items_path)
    end
  end
end