require 'rails_helper'

describe CategoriesController do
  before do
    initialize_current_user
    @category = mock_model(Category, :update_attributes => true, :destroy => true)
    Category.stub(:where).and_return([@category])
  end

  shared_examples_for "request which sets category" do
    it "finds category" do
      expect(Category).to receive(:where).with(:id => "id")
      send_request
    end

    it "sets category" do
      send_request
      expect(assigns(:category)).to eq(@category)
    end

    context "when category not found" do
      before do
        Category.stub(:where).and_return([])
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("Category not found")
      end

      it "redirects to categories index" do
        send_request
        expect(response).to redirect_to(categories_path)
      end
    end
  end

  describe "GET index" do
    before do
      @categories = double("categories")
      Category.stub(:all).and_return(@categories)
    end

    def send_request
      get :index
    end

    it "finds all categories" do
      expect(Category).to receive(:all)
      send_request
    end

    it "sets @categories" do
      send_request
      expect(assigns(:categories)).to eq(@categories)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do

    before do
      @category = mock_model(Category)
      Category.stub(:new).and_return(@category)
    end

    def send_request
      get :new
    end

    it "initializes category" do
      expect(Category).to receive(:new)
      send_request
    end

    it "sets @category" do
      send_request
      expect(assigns(:category)).to eq(@category)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @category = mock_model(Category, :save => true)
      Category.stub(:new).and_return(@category)
    end

    def send_request
      post :create, :category => category_params
    end

    def category_params
      { "name" => "category_name" }
    end

    it "initializes category" do
      expect(Category).to receive(:new).with(category_params)
      send_request
    end

    it "sets @category" do
      send_request
      expect(assigns(:category)).to eq(@category)
    end

    it "saves category" do
      expect(@category).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to categories index" do
        send_request
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when not saved successfully" do
      before do
        @category.stub(:save).and_return(false)
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

    it_behaves_like "request which sets category"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    def send_request
      put :update, :id => 'id', :category => category_params
    end

    def category_params
      { "name" => "category_name" }
    end

    it_behaves_like "request which sets category"

    it "updates attributes" do
      expect(@category).to receive(:update_attributes).with(category_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to categories index" do
        send_request
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when not updated successfully" do
      before do
        @category.stub(:update_attributes).and_return(false)
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

    it_behaves_like "request which sets category"

    it "destroys category" do
      expect(@category).to receive(:destroy)
      send_request
    end

    context "when deleted successfully" do
      it "redirects to categories index" do
        send_request
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when not deleted successfully" do
      before do
        @category.stub(:destroy).and_return(false)
        @category.errors[:base] << "error"
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("error")
      end

      it "redirects to categories index" do
        send_request
        expect(response).to redirect_to(categories_path)
      end
    end
  end
end