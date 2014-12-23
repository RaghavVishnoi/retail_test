require 'rails_helper'

describe BusinessUnitsController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @business_unit = mock_model(BusinessUnit, :update_attributes => true)
    BusinessUnit.stub(:where).and_return([@business_unit])
  end

  shared_examples_for "request which sets business unit" do
    it "finds business unit" do
      expect(BusinessUnit).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @business_unit" do
      send_request
      expect(assigns(:business_unit)).to eq(@business_unit)
    end

    context "when business_unit not found" do
      before do
        BusinessUnit.stub(:where).and_return([])
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(business_units_url)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Business Unit not found")
      end
    end
  end

  describe "GET index" do
    before do
      @business_units = double("business units")
      BusinessUnit.stub(:all).and_return(@business_units)
    end

    def send_request
      get :index
    end

    it "finds all business units" do
      expect(BusinessUnit).to receive(:all)
      send_request
    end

    it "sets @business_units" do
      send_request
      expect(assigns(:business_units)).to eq(@business_units)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @business_unit = mock_model(BusinessUnit)
      BusinessUnit.stub(:new).and_return(@business_unit)
    end

    def send_request
      get :new
    end

    it "initializes new business unit" do
      expect(BusinessUnit).to receive(:new)
      send_request
    end

    it "sets @business_unit" do
      send_request
      expect(assigns(:business_unit)).to eq(@business_unit)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @business_unit = mock_model(BusinessUnit, :save => true)
      BusinessUnit.stub(:new).and_return(@business_unit)
    end

    def send_request
      post :create, :business_unit => business_unit_params
    end

    def business_unit_params
      { 'name' => 'business_unit_name' }
    end

    it "initializes new business unit" do
      expect(BusinessUnit).to receive(:new).with(business_unit_params)
      send_request
    end

    it "sets @business_unit" do
      send_request
      expect(assigns(:business_unit)).to eq(@business_unit)
    end

    it "saves" do
      expect(@business_unit).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(business_units_url)
      end
    end

    context "when not saved successfully" do
      before do
        @business_unit.stub(:save).and_return(false)
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

    it_behaves_like "request which sets business unit"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :business_unit => business_unit_params
    end

    def business_unit_params
      { 'name' => 'business unit name' }
    end

    it_behaves_like "request which sets business unit"

    it "updates business unit" do
      expect(@business_unit).to receive(:update_attributes).with(business_unit_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(business_units_url)
      end
    end

    context "when not updated successfully" do
      before do
        @business_unit.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets business unit"

    it "destroys business_unit" do
      expect(@business_unit).to receive(:destroy)
      send_request
    end

    it "redirects to business_units_url" do
      send_request
      expect(response).to redirect_to(business_units_url)
    end
  end
end