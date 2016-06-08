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

        protected
          def self.set_pagination_headers(name, options = {})
               after_filter(options) do |controller|
                results = instance_variable_get("@#{name}")
                headers["X-Pagination"] = {
                  total: results.total_entries,
                  total_pages: results.total_pages,
                  first_page: results.current_page == 1,
                  last_page: results.next_page.blank?,
                  previous_page: results.previous_page,
                  next_page: results.next_page,
                  out_of_bounds: results.out_of_bounds?,
                  offset: results.offset
                }.to_json
              end
          end
        
    end
  end
end
