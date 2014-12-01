module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_user_from_token, :only => [:create]
      before_action :find_user_by_email, :only => [:create]

      def create
        if @user.valid_password?(params[:password])
          render :json => { :result => true, :auth_token => @user.auth_token, :role => @user.role, :email => @user.email, :quotation => Quotation.any }
        else
          render :json => { :result => false, :errors => { :messages => ['Invalid Password'] } }
        end
      end

      def destroy
        current_user.auth_token = nil
        current_user.save
        render :json => { :result => true }
      end

      private
        def find_user_by_email
          @user = User.where(:email => params[:email]).first if params[:email]
          unless @user
            render :json => { :result => false, :errors => { :messages => ["User not found"] } }
          end
        end
    end
  end
end