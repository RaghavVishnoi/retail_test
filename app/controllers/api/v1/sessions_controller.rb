module Api
  module V1
    class SessionsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user, :only => [:create]
      before_action :find_user_by_email, :only => [:create]

      def create
        if @user.authenticate(params[:password])
          render :json => { :result => true, :auth_token => @user.auth_token, :email => @user.email, :quotation => Quotation.any, :personalized_message => @user.personalized_message }
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
          @user = User.with_password.with_email(params[:email]).first if params[:email]
          unless @user
            render :json => { :result => false, :errors => { :messages => ["User not found"] } }
          end
        end
    end
  end
end
