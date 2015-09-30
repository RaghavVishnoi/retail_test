module Api
  module V1
    class SessionsController < BaseController
    	skip_authorize_resource
    	skip_before_action :authenticate_user 
 
      
  		def create
           
           @user = User.with_password.with_email(params[:session][:email]).first if params[:session][:email]
           if @user == nil || @user == ''
            render :json => { :result => false, :message => 'Login id/password does not match'}
           else
            @role = User.user_role(@user.id)
             if (@role.name == 'requester' && params[:request][:app_id] == '1' && @user.status == 'Active') || (@role.name == 'vendor' && params[:request][:app_id] == '2' && @user.status == 'Active')
               if @user && @user.authenticate(params[:session][:password])
                 sign_in @user
                 if @role.name == 'vendor'
                  vendor = Vendorlist.find_by(:email => @user.email)
                  render :json => { :result => true, :user => @user, :vendor_id => vendor.id}
                 else
                  render :json => { :result => true, :user => @user}
                 end

                 
  		         else
  		           render :json => { :result => false, :message => 'Login id/password does not match'}
  		         end
            else
                 render :json => { :result => false, :message => 'Login id/password does not match'}
            end
          end
      end

      def forgot_password

        email = params[:session][:email]
        @user = User.find_by(:email => email)
        @role = User.user_role(@user.id)
        if @user == nil || @user == ''
          render :json => { :result => false, :message => 'Email Id does not exist'}
        else
          generated_password = Devise.friendly_token.first(8)
          @user.update_attributes(:name => @user.name,:email => @user.email,:status => @user.status, :password => generated_password,:password_confirmation => generated_password)
          PasswordMailer.delay.forgot_password_mail(@user.email,generated_password)
          render :json => { :result => true,:message => 'Your password id sent to #{@user.email}'}
        end

      end

      def change_password
        token = params[:session][:auth_token]
        @user = User.find_by(:auth_token => token)
        @role = User.user_role(@user.id)
        if @user != nil && @user != ''
          if @user && @user.authenticate(params[:session][:old_password])
             if params[:session][:new_password] == params[:session][:confirm_password]
               @user.update_attributes(:name => @user.name,:email => @user.email,:status => @user.status, :password => params[:session][:new_password],:password_confirmation => params[:session][:confirm_password])
               render :json => { :result => true, :message => 'Your passwoed changed successfully'}
             else
              render :json => { :result => false, :message => 'New password and confirm password does not match'}
             end
          else
             render :json => { :result => false, :message => 'Old password does not match'}
          end
        else
             render :json => { :result => false, :message => 'Please login again'}
        end

      end

      def destroy
          sign_out
          render :json => { :result => true, :message => 'successfully logout'}
      end
    end
  end
end