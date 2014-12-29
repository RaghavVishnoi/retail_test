require 'rails_helper'

describe SessionsController do
  describe "GET new" do
    def send_request
      get :new
    end

    it "renders new template" do
      send_request
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      @user = mock_model(User, :authenticate => true)
      @users_with_passwords = double("users_with_passwords")
      User.stub(:with_password).and_return(@users_with_passwords)
      @users_with_passwords.stub(:with_email).and_return([])
    end

    def send_request
      post :create, params
    end

    def params
      { :email => 'email', :password => 'password' }
    end

    shared_examples_for "authentication failure" do
      it "redirects to sign_in path" do
        send_request
        expect(response).to redirect_to(users_sign_in_path)
      end

      it "sets flash alert" do
        send_request
        expect(flash[:alert]).to eq("Invalid email or password")
      end
    end

    context "when params[:email] present" do
      it "finds user by email" do
        expect(@users_with_passwords).to receive(:with_email).with("email")
        send_request
      end

      context "when user exists" do
        before do
          @users_with_passwords.stub(:with_email).and_return([@user])
        end

        it "authenticates user" do
          expect(@user).to receive(:authenticate).with('password')
          send_request
        end

        context "when authenticated successfully" do
          it "signs in user" do
            send_request
            expect(session[:user_id]).to eq(@user.id)
          end

          it "redirects to profile_path" do
            send_request
            expect(response).to redirect_to([:edit, @user])
          end
        end

        context "when not authenticated" do
          before do
            @user.stub(:authenticate).and_return(false)
          end
          
          it_behaves_like "authentication failure"
        end
      end

      context "when user does not exist" do
        it_behaves_like "authentication failure"
      end
    end

    context "when email not present in params" do
      def params
        {}
      end
      it_behaves_like "authentication failure"
    end
  end

  describe "DELETE destroy" do
    before do
      @user = mock_model(User)
      session[:user_id] = @user.id
      User.stub(:where).and_return([@user])
    end

    def send_request
      delete :destroy
    end
    
    it "signs out user" do
      send_request
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to sign_in path" do
      send_request
      expect(response).to redirect_to(users_sign_in_path)
    end

    it "sets flash notice" do
      send_request
      expect(flash[:notice]).to eq("You have been signed out successfully")
    end
  end
end