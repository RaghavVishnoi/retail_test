require 'rails_helper'

describe JobTitlesController do
  before do
    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)

    @job_title = mock_model(JobTitle, :update_attributes => true)
    JobTitle.stub(:where).and_return([@job_title])
  end

  shared_examples_for "request which sets job title" do
    it "finds job title" do
      expect(JobTitle).to receive(:where).with(:id => 'id')
      send_request
    end

    it "sets @job_title" do
      send_request
      expect(assigns(:job_title)).to eq(@job_title)
    end

    context "when job_title not found" do
      before do
        JobTitle.stub(:where).and_return([])
      end

      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(job_titles_url)
      end

      it "sets alert" do
        send_request
        expect(flash[:alert]).to eq("Job Title not found")
      end
    end
  end

  describe "GET index" do
    before do
      @job_titles = double("job titles")
      JobTitle.stub(:all).and_return(@job_titles)
    end

    def send_request
      get :index
    end

    it "finds all job titles" do
      expect(JobTitle).to receive(:all)
      send_request
    end

    it "sets @job_titles" do
      send_request
      expect(assigns(:job_titles)).to eq(@job_titles)
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @job_title = mock_model(JobTitle)
      JobTitle.stub(:new).and_return(@job_title)
    end

    def send_request
      get :new
    end

    it "initializes new job title" do
      expect(JobTitle).to receive(:new)
      send_request
    end

    it "sets @job_title" do
      send_request
      expect(assigns(:job_title)).to eq(@job_title)
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @job_title = mock_model(JobTitle, :save => true)
      JobTitle.stub(:new).and_return(@job_title)
    end

    def send_request
      post :create, :job_title => job_title_params
    end

    def job_title_params
      { 'title' => 'job title' }
    end

    it "initializes new job_title" do
      expect(JobTitle).to receive(:new).with(job_title_params)
      send_request
    end

    it "sets @job_title" do
      send_request
      expect(assigns(:job_title)).to eq(@job_title)
    end

    it "saves" do
      expect(@job_title).to receive(:save)
      send_request
    end

    context "when saved successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(job_titles_url)
      end
    end

    context "when not saved successfully" do
      before do
        @job_title.stub(:save).and_return(false)
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

    it_behaves_like "request which sets job title"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end

  end

  describe "PUT update" do

    def send_request
      put :update, :id => 'id', :job_title => job_title_params
    end

    def job_title_params
      { 'title' => 'job title' }
    end

    it_behaves_like "request which sets job title"

    it "updates job title" do
      expect(@job_title).to receive(:update_attributes).with(job_title_params)
      send_request
    end

    context "when updated successfully" do
      it "redirects to index page" do
        send_request
        expect(response).to redirect_to(job_titles_url)
      end
    end

    context "when not updated successfully" do
      before do
        @job_title.stub(:update_attributes).and_return(false)
      end

      it "renders edit page" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end
end