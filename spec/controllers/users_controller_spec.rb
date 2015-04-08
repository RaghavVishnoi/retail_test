require 'rails_helper'

describe UsersController do
  before do
    initialize_current_user
    @user = mock_model(User)
    User.stub(:where).with(:id => 'id').and_return([@user])
  end

  shared_examples_for "request which sets user" do
    it "finds user" do
      expect(User).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @user" do
      send_request
      expect(assigns(:user)).to eq(@user)
    end

    context "when user not found" do
      before do
        User.stub(:where).and_return([])
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("User not found")
      end

      it "redirects to users index" do
        send_request
        expect(response).to redirect_to(users_url)
      end
    end
  end

  describe "GET index" do
    before do
      @users = double("users")
      User.stub(:all).and_return(@users)
    end
    
    def send_request
      get :index
    end
    
    it "fetches all users" do
      expect(User).to receive(:all)
      send_request
    end

    it "sets @users" do
      send_request
      expect(assigns(:users)).to eq(@users)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    def send_request
      get :new
    end

    before do
      @user = mock_model(User)
      User.stub(:new).and_return(@user)
    end

    it "initializes new user" do
      expect(User).to receive(:new)
      send_request
    end

    it "sets @user" do
      send_request
      expect(assigns(:user)).to eq(@user)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "GET edit" do

    def send_request
      get :edit, :id => 'id'
    end
    
    it_behaves_like 'request which sets user'

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    before do
      @user.stub(:update_attributes).and_return(true)
    end

    def send_request
      put :update, :id => 'id', :user => user_params
    end

    def user_params
      { 'name' => 'name', 'email' => 'email', 'password' => 'password', 'password_confirmation' => 'password', 'department_ids' =>'1, 2', 'region_ids' => ['1', '2'], 'business_unit_ids' => ['1', '2'], 'job_title_ids' => ['1', '2'], 'weekly_off_ids' => ['1', '2'], 'skip_password_validation' => true }
    end
    
    it_behaves_like "request which sets user" 

    it "updates attributes" do
      expect(@user).to receive(:update_attributes).with(user_params)
      send_request
    end
    
    context "when updated successfully" do
      it "sets flash notice" do
        send_request
        expect(flash[:notice]).to eq("Updated successfully")
      end

      it "redirects to edit path" do
        send_request
        expect(response).to redirect_to([:edit, @user])
      end
    end

    context "when not updated successfully" do
      before do
        @user.stub(:update_attributes).and_return(false)
      end

      it "renders edit path" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST create" do

    before do
      @user = mock_model(User, :save => true)
      User.stub(:new).and_return(@user)
    end

    def send_request
      post :create, :user => user_params
    end

    def user_params
      { 'name' => 'name', 'email' => 'email', 'password' => 'password', 'password_confirmation' => 'password', 'department_ids' =>'1, 2', 'region_ids' => ['1', '2'], 'business_unit_ids' => ['1', '2'], 'job_title_ids' => ['1', '2'], 'weekly_off_ids' => ['1', '2'], 'skip_password_validation' => true }
    end

    it "initializes new user" do
      expect(User).to receive(:new).with(user_params)
      send_request
    end

    it "sets @user" do
      send_request
      expect(assigns(:user)).to eq(@user)
    end

    it "saves user" do
      expect(@user).to receive(:save)
      send_request
    end

    context "when user saved successfully" do
      it "sets flash notice" do
        send_request
        expect(flash[:notice]).to eq("User created successfully")
      end

      it "redirects to users index" do
        send_request
        expect(response).to redirect_to(users_path)
      end
    end

    context "when user not saved successfully" do

      before do
        @user.stub(:save).and_return(false)
      end

      it "renders new template" do
        send_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE destroy" do

    def send_request
      delete :destroy, :id => 'id'
    end

    it_behaves_like "request which sets user"
    
    it "deletes user" do
      expect(@user).to receive(:destroy)
      send_request
    end

    it "sets flash notice" do
      send_request
      expect(flash[:notice]).to eq("User deleted successfully")
    end

    it "redirects to users index" do
      send_request
      expect(response).to redirect_to(users_url)
    end
  end
end