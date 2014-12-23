require 'rails_helper'

describe OrganizationsController do
  before do
    @organization = mock_model(Organization, :update_attributes => true)
    expect(Organization).to receive(:first).and_return(@organization)

    @user = mock_model(User, :superadmin? => true)
    expect(controller).to receive(:authenticate_user).and_return(nil)
    expect(controller).to receive(:current_user).and_return(@user)
  end

  shared_examples_for "request which sets organization" do
    it "sets organization" do
      send_request
      expect(assigns(:organization)).to eq(@organization)
    end
  end

  describe "GET edit" do

    def send_request
      get :edit
    end

    it_behaves_like "request which sets organization"

    it "renders edit template" do
      send_request
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do

    def send_request
      put :update, :organization => organization_params
    end

    def organization_params
      { 'name' => 'organization_name' }
    end
    
    it_behaves_like "request which sets organization"

    it "updates organization" do
      expect(@organization).to receive(:update_attributes).with(organization_params)
      send_request
    end

    context "when updated successfully" do
      before do
        expect(@organization).to receive(:update_attributes).and_return(true)
      end

      it "redirects to edit url" do
        send_request
        expect(response).to redirect_to(organization_edit_url)
      end
    end
    
    context "when not updated" do
      before do
        expect(@organization).to receive(:update_attributes).and_return(false)
      end

      it "renders edit template" do
        send_request
        expect(response).to render_template(:edit)
      end
    end
  end
end