require 'rails_helper'

describe WeeklyOffsController do
  before do
    initialize_current_user
  end

  describe "GET index" do
    def send_request
      get :index
    end

    it "renders index template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "POST create" do
    before do
      @weekly_offs = double("weekly offs", :destroy_all => nil)
      WeeklyOff.stub(:where).and_return(@weekly_offs)
    end

    def send_request
      post :create, :days => ['0', '1']
    end

    it "creates weekly offs" do
      expect(WeeklyOff).to receive(:create).twice
      send_request
    end

    it "finds weekly offs which are not present in params" do
      expect(WeeklyOff).to receive(:where).exactly(5).times
      send_request
    end

    it "destroys weekly offs" do
      expect(@weekly_offs).to receive(:destroy_all).exactly(5).times
      send_request
    end

    it "redirects to weekly_offs_url" do
      send_request
      expect(response).to redirect_to(weekly_offs_url)
    end
  end

  describe "#weekly_off_params" do
    def weekly_off_params
      controller.send :weekly_off_params
    end

    context "when params is a array" do
      before do
        controller.params = { :days => ['0', '1'] }
      end

      it "returns days" do
        expect(weekly_off_params).to eq(['0', '1'])
      end
    end
    context "when params is not array" do
      before do
        controller.params = { :days => "0, 1" }
      end

      it "returns empty array" do
        expect(weekly_off_params).to eq([])
      end
    end
  end
end