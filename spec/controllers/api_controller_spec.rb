require 'rails_helper'

RSpec.describe ApiController, :type => :controller do

  describe "GET v1" do
    it "returns http success" do
      get :v1
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET citylists" do
    it "returns http success" do
      get :citylists
      expect(response).to have_http_status(:success)
    end
  end

end
