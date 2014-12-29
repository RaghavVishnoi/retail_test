require 'rails_helper'

describe DepartmentsController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @department = mock_model(Department, :update_attributes => true)
    Department.stub(:where).and_return([@department])
  end

  shared_examples_for "request which sets department" do
    it "finds department" do
      expect(Department).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @department" do
      send_request
      expect(assigns(:department)).to eq(@department)
    end

    context "when department not found" do
      before do
        Department.stub(:where).and_return([])
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(departments_url)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Department not found")
      end
    end
  end

  describe "GET index" do
    before do
      @departments = double("departments")
      Department.stub(:all).and_return(@departments)
    end

    def send_request
      get :index
    end

    it "finds all departments" do
      expect(Department).to receive(:all)
      send_request
    end

    it "sets @departments" do
      send_request
      expect(assigns(:departments)).to eq(@departments)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @department = mock_model(Department)
      Department.stub(:new).and_return(@department)
    end

    def send_request
      get :new
    end

    it "initializes new department" do
      expect(Department).to receive(:new)
      send_request
    end

    it "sets @department" do
      send_request
      expect(assigns(:department)).to eq(@department)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @department = mock_model(Department, :save => true)
      Department.stub(:new).and_return(@department)
    end

    def send_request
      post :create, :department => department_params
    end

    def department_params
      { 'name' => 'department name' }
    end

    it "initializes new department" do
      expect(Department).to receive(:new).with(department_params)
      send_request
    end

    it "sets @department" do
      send_request
      expect(assigns(:department)).to eq(@department)
    end

    it "saves" do
      expect(@department).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(departments_url)
      end
    end

    context "when not saved successfully" do
      before do
        @department.stub(:save).and_return(false)
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

    it_behaves_like "request which sets department"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :department => department_params
    end

    def department_params
      { 'name' => 'department name' }
    end

    it_behaves_like "request which sets department"

    it "updates department" do
      expect(@department).to receive(:update_attributes).with(department_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(departments_url)
      end
    end

    context "when not updated successfully" do
      before do
        @department.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets department"

    it "destroys department" do
      expect(@department).to receive(:destroy)
      send_request
    end

    it "redirects to departments_url" do
      send_request
      expect(response).to redirect_to(departments_url)
    end
  end
end