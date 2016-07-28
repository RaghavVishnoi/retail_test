require 'rails_helper'

describe InventoriesController do
  before do
    initialize_current_user
    @inventory = mock_model(Inventory, :update_attributes => true, :destroy => true)
    @inventories = double("inventories")
    @inventories.stub(:where).and_return([@inventory])
    @item = mock_model(Item, :inventories => @inventories)
    Item.stub(:where).and_return([@item])
  end

  shared_examples_for "request which sets item" do
    it "finds item" do
      expect(Item).to receive(:where).with(:id => 'item_id')
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

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("Item not found")
      end

      it "redirects to items index" do
        send_request
        expect(response).to redirect_to(items_path)
      end
    end
  end

  shared_examples_for "request which sets inventory" do
    it "finds inventory" do
      expect(@inventories).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @inventory" do
      send_request
      expect(assigns(:inventory)).to eq(@inventory)
    end

    context "when inventory not found" do
      before do
        @inventories.stub(:where).and_return([])
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("Inventory not found")
      end

      it "redirects to inventories index" do
        send_request
        expect(response).to redirect_to(item_inventories_path(@item))
      end
    end
  end

  describe "GET index" do

    def send_request
      get :index, :item_id => 'item_id'
    end

    it_behaves_like "request which sets item"

    it "finds inventories" do
      expect(@item).to receive(:inventories)
      send_request
    end

    it "sets @inventories" do
      send_request
      expect(assigns(:inventories)).to eq(@inventories)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @inventory = mock_model(Inventory)
      @inventories.stub(:new).and_return(@inventory)
    end

    def send_request
      get :new, :item_id => 'item_id'
    end

    it_behaves_like "request which sets item"

    it "initializes inventory" do
      expect(@inventories).to receive(:new)
      send_request
    end

    it "sets @inventory" do
      send_request
      expect(assigns(:inventory)).to eq(@inventory)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @inventory = mock_model(Inventory, :save => true)
      @inventories.stub(:new).and_return(@inventory)
    end

    def send_request
      post :create, :item_id => 'item_id', :inventory => inventory_params
    end

    def inventory_params
      { "quantity" => 'quantity', "warehouse_id" => 'warehouse_id', "low_stock_trigger_quantity" => "low_stock_trigger_quantity", "restock_time" => "restock_time" }
    end

    it_behaves_like "request which sets item"

    it "initializes inventory" do
      expect(@inventories).to receive(:new).with(inventory_params)
      send_request
    end

    it "sets inventory" do
      send_request
      expect(assigns(:inventory)).to eq(@inventory)
    end

    it "saves inventory" do
      expect(@inventory).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to inventories index" do
        send_request
        expect(response).to redirect_to(item_inventories_path(@item))
      end
    end

    context "when not saved successfully" do
      before do
        @inventory.stub(:save).and_return(false)
      end

      it "renders new template" do
        send_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    def send_request
      get :edit, :item_id => 'item_id', :id => 'id'
    end

    it_behaves_like "request which sets item"

    it_behaves_like "request which sets inventory"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    def send_request
      put :update, :item_id => 'item_id', :id => 'id', :inventory => inventory_params
    end

    def inventory_params
      { "quantity" => 'quantity', "warehouse_id" => 'warehouse_id', "low_stock_trigger_quantity" => "low_stock_trigger_quantity", "restock_time" => "restock_time" }
    end

    it_behaves_like "request which sets item"

    it_behaves_like "request which sets inventory"

    it "updates attributes" do
      expect(@inventory).to receive(:update_attributes).with(inventory_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to inventories index" do
        send_request
        expect(response).to redirect_to(item_inventories_path(@item))
      end
    end

    context "when not updated successfully" do
      before do
        @inventory.stub(:update_attributes).and_return(false)
      end

      it "renders edit template" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    def send_request
      delete :destroy, :item_id => 'item_id', :id => 'id'
    end

    it_behaves_like "request which sets item"

    it_behaves_like "request which sets inventory"

    it "destroys inventory" do
      expect(@inventory).to receive(:destroy)
      send_request
    end

    context "when inventory deleted successfully" do
      it "redirects to inventories index" do
        send_request
        expect(response).to redirect_to(item_inventories_path(@item))
      end
    end

    context "when inventory not deleted successfully" do
      before do
        @inventory.stub(:destroy).and_return(false)
        @inventory.errors[:base] << "error"
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("error")
      end

      it "redirects to inventories index" do
        send_request
        expect(response).to redirect_to(item_inventories_path(@item))
      end
    end
  end
end