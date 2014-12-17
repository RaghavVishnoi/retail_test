class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_sign_in_url, alert: "Access denied!"
  end

  before_action :log_requests
  before_action :authenticate_user

  private
    def log_requests
      LogHandler.process(request)
    end

    def authenticate_user
      unless current_user
        redirect_to users_sign_in_url, alert: 'You need to login'
      end
    end

    def current_user
      @current_user ||= User.where(:id => session[:user_id]).first
    end

    def sign_in user
      session[:user_id] = user.id
    end

    def sign_out
      session[:user_id] = nil
    end

    def home_page_url
      [:edit, current_user]
    end
end
