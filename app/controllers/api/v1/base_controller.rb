module Api
  module V1
    class BaseController < ApplicationController      
      skip_before_action :verify_authenticity_token

      private

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
