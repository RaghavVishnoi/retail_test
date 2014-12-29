require 'rails_helper'

describe AddressesController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @address = mock_model(Address, :update_attributes => true)
    Address.stub(:where).and_return([@address])
  end

  shared_examples_for "request which sets address" do
    it "finds address" do
      expect(Address).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @address" do
      send_request
      expect(assigns(:address)).to eq(@address)
    end

    context "when address not found" do
      before do
        Address.stub(:where).and_return([])
      end

      it "redirects to organization edit" do
        send_request
        expect(response).to redirect_to(organization_edit_url)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Address not found")
      end
    end
  end

  describe "GET index" do
    before do
      @addresses = double("addresses")
      Address.stub(:branch_offices).and_return(@addresses)
    end

    def send_request
      get :index
    end

    it "finds all addresses" do
      expect(Address).to receive(:branch_offices)
      send_request
    end

    it "sets @addresses" do
      send_request
      expect(assigns(:addresses)).to eq(@addresses)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @address = mock_model(Address)
      Address.stub(:new).and_return(@address)
    end

    def send_request
      get :new
    end

    it "initializes new address" do
      expect(Address).to receive(:new)
      send_request
    end

    it "sets @address" do
      send_request
      expect(assigns(:address)).to eq(@address)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @address = mock_model(Address, :save => true)
      Address.stub(:new).and_return(@address)
    end

    def send_request
      post :create, :address => address_params
    end

    def address_params
      { 'address' => 'address', 'city' => 'city', 'state' => 'state', 'country' => 'country' }
    end

    it "initializes new address" do
      expect(Address).to receive(:new).with(address_params)
      send_request
    end

    it "sets @address" do
      send_request
      expect(assigns(:address)).to eq(@address)
    end

    it "saves" do
      expect(@address).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to addresses url" do
        send_request
        expect(response).to redirect_to(addresses_url)
      end
    end

    context "when not saved successfully" do
      before do
        @address.stub(:save).and_return(false)
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

    it_behaves_like "request which sets address"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "GET edit_hq" do

    before do
      @hq_address = mock_model(Address)
      Address.stub(:hq).and_return(@hq_address)
    end

    def send_request
      get :edit_hq
    end

    it "finds headquarter address" do
      expect(Address).to receive(:hq)
      send_request
    end

    it "sets @address" do
      send_request
      expect(assigns(:address)).to eq(@hq_address)
    end
    
    it "renders edit_hq template" do
      send_request
      expect(response).to render_template(:edit_hq)
    end
  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :address => address_params
    end

    def address_params
      { 'address' => 'address', 'city' => 'city', 'state' => 'state', 'country' => 'country' }
    end

    it_behaves_like "request which sets address"

    it "updates address" do
      expect(@address).to receive(:update_attributes).with(address_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index" do
        send_request
        expect(response).to redirect_to(addresses_url)
      end
    end

    context "when not updated successfully" do
      before do
        @address.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets address"

    it "destroys address" do
      expect(@address).to receive(:destroy)
      send_request
    end

    it "redirects to addresses_url" do
      send_request
      expect(response).to redirect_to(addresses_url)
    end
  end
end