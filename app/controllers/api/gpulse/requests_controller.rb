module Api
  module Gpulse
    class RequestsController < BaseController
    	include DateHelper
         include RequestsHelper
          skip_before_action :verify_authenticity_token

      def shop_info
          state = params[:state]
          start_date = params[:start_date]
          end_date   = params[:end_date]
          shop_info = shop_data(state,start_date,end_date)
          render :json => {:result =>  true,:object => shop_info}
      end    

    	def shop_branding
            result = date_valid(params[:start_date],params[:end_date])
            if result == '0'
                render :json => {:result => false,:message => t('date.validation.errors.format')}
            else
                if result == '1'
                    render :json => {:result => false,:message => t('date.validation.errors.range')}
                else
                    start_date = cast_date(params[:start_date])
                    end_date = cast_date(params[:end_date])
                    request = shop_branding_details(start_date,end_date,params[:state])
                        
                    
                    render :json => {:result => true,:object => request}
                end
            end
    	end

        def shop_list
          result = date_valid(params[:start_date],params[:end_date])
            if result == '0'
                render :json => {:result => false,:message => t('date.validation.errors.format')}
            else
                if result == '1'
                    render :json => {:result => false,:message => t('date.validation.errors.range')}
                else
                    request_type = params[:request_type]
                    state = params[:state]
                    if request_type == nil || request_type.length == 0
                        render :json => {:result => false,:message => t('request.validation.errors.exist.type')}
                    elsif state == nil || state.length == 0
                            render :json => {:result => false,:message => t('state.validation.errors.exist')} 
                    else
                      start_date = cast_date(params[:start_date])
                      end_date = cast_date(params[:end_date])
                      request = shop_list_details(start_date,end_date,request_type,state)                                            
                      render :json => {:result => true,:object => request}
                  end 
                end
            end
        end

        def request_data
             id = params[:id]
             if id == nil || id.length == 0
                render :json => {:result => false,:message => t('request.validation.errors.exist.id')} 
             else
                @request = request_details(id)
                render :json => {:result => true,:object => @request}
             end
        end

        def status_count(status,type)
             Request.where(:status => status,:request_type => type).length
        end

        def total_count(type)
             Request.where(:request_type => type).length
        end


    	
    end
  end
end