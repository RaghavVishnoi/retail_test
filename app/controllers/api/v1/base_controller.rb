module Api
  module V1
    class BaseController < ApplicationController      
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user_from_token

      private
        def authenticate_user_from_token
          unless current_user
            render :json => { :result => false, :errors => { :messages => ["User not found"] } }
          end
        end

        def current_user
          @current_user ||= find_user_by_token
        end

        def find_user_by_token
          if params[:auth_token]
            User.where(:auth_token => params[:auth_token]).first
          end
        end

        def current_address_state
          @current_address_state ||= fetch_state_by_coordinates
        end

        def fetch_state_by_coordinates
          if params[:latitude] && params[:longitude]
            begin
              g = Geocoder.search([params[:latitude], params[:longitude]]).first
              g.state
            rescue
              nil
            end
          end
        end
        
    end
  end
end