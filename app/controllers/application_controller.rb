class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'will_paginate/array'
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, :if => "request.format.json?"
  after_filter :add_allow_credentials_headers

  helper_method :current_user, :logged_in?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to users_sign_in_url, alert: "Access denied!" }
      format.json { render :json => { :result => true,:messages => "Access denied!" } }
    end
  end

  # before_action :log_requests, :if => 'Rails.env.staging?'
  before_action :authenticate_user

  private
    def add_allow_credentials_headers                                                                                                                                                                                                                                                        
      response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'                                                                                                                                                                                                     
      response.headers['Access-Control-Allow-Credentials'] = 'true'                                                                                                                                                                                                                          
    end 

    def log_requests
      LogHandler.process(request)
    end

    def authenticate_user
      unless logged_in?
        respond_to do |format|
          format.html { redirect_to users_sign_in_url, alert: 'You need to login' }
          format.json { render :json => { :result => false, :errors => { :messages => ["User not found"] } } }
        end
      end
     end

    def find_user
      if params[:auth_token]
        User.where(:auth_token => params[:auth_token]).first
      elsif session[:user_id]
        User.where(:id => session[:user_id]).first
      end
    end
    
    def current_user
      @current_user ||= find_user
    end

    def sign_in user
      session[:user_id] = user.id
    end

    def sign_out
      session[:user_id] = nil
    end

    def logged_in?
      !!current_user
    end

    def updated_at
      @updated_at ||= Time.parse(params[:updated_at]) rescue nil
    end

    def initialize_resources
      instance_variable_set(resources_instance, resources)
    end

    def resources
      updated_at.present? ? resource_class.where("#{resource_class.table_name}.updated_at > ?", updated_at) : resource_class
    end

    def resource_class
      controller_name.camelize.singularize.constantize
    end

    def resources_instance
      "@#{controller_name}"
    end

    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
      }
    end
end
