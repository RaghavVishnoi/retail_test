require 'rails_helper'

describe CitiesController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @city = mock_model(City, :update_attributes => true, :destroy => true)
    City.stub(:where).and_return([@city])
  end

  shared_examples_for "request which sets city" do
    it "finds city" do
      expect(City).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @city" do
      send_request
      expect(assigns(:city)).to eq(@city)
    end

    context "when city not found" do
      before do
        expect(City).to receive(:where).and_return([])
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("City not found")
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(cities_path)
      end
    end
  end

  describe "GET index" do
    before do
      @cities = double("cities")
      City.stub(:paginate).and_return(@cities)
    end

    def send_request
      get :index
    end

    it "paginates cities" do
      expect(City).to receive(:paginate)
      send_request
    end

    it "sets @cities" do
      send_request
      expect(assigns(:cities)).to eq(@cities)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @city = mock_model(City)
      City.stub(:new).and_return(@city)
    end

    def send_request
      get :new
    end

    it "initializes city" do
      expect(City).to receive(:new)
      send_request
    end

    it "sets @city" do
      send_request
      expect(assigns(:city)).to eq(@city)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do

    before do
      @city = mock_model(City, :save => true)
      City.stub(:new).and_return(@city)
    end

    def send_request
      post :create, :city => city_params
    end

    def city_params
      { "name" => "city_params" }
    end

    it "initializes city with params" do
      expect(City).to receive(:new).with(city_params)
      send_request
    end

    it "sets @city" do
      send_request
      expect(assigns(:city)).to eq(@city)
    end

    it "saves city" do
      expect(@city).to receive(:save)
      send_request
    end

    context "when city saved successfully" do
      before do
        @city.stub(:save).and_return(true)
      end

      it "redirects to index" do
        send_request
        expect(response).to redirect_to(cities_path)
      end
    end

    context "when city not saved successfully" do
      before do
        @city.stub(:save).and_return(false)
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

    it_behaves_like "request which sets city"
    
    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    def send_request
      put :update, :id => 'id', :city => city_params
    end

    def city_params
      { "name" => "city_name" }
    end

    it_behaves_like "request which sets city"

    it "updates attributes" do
      expect(@city).to receive(:update_attributes).with(city_params)
      send_request
    end

    context "when updated successfully" do
      before do
        @city.stub(:update_attributes).and_return(true)
      end

      it "redirects to cities index" do
        send_request
        expect(response).to redirect_to(cities_path)
      end
    end

    context "when not updated successfully" do
      before do
        @city.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets city"

    it "destroys city" do
      expect(@city).to receive(:destroy)
      send_request
    end

    context "when deleted successfully" do
      it "redirects to cities index" do
        send_request
        expect(response).to redirect_to(cities_path)
      end
    end

    context "when not deleted successfully" do
      before do
        @city.stub(:destroy).and_return(false)
        @city.errors[:base] << "error"
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("error")
      end

      it "redirects to cities index" do
        send_request
        expect(response).to redirect_to(cities_path)
      end
    end
  end
end