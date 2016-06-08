module Api
  module V1
    class VendorsController < BaseController
    	
      skip_authorize_resource
    	#skip_before_action :authenticate_user 
    	
    	def assignments
        assignments = RequestAssignment.where('upload_bill != 2 AND user_id = ?',current_user.id)
        render :json => {result: true,object: assignments.select(:id,:request_id)}
    	end

      def shopInfo
        request = Request.find(params[:request_id])
        @shopData = Retailer.find_by(retailer_code: request.retailer_code)
        render :shop_info
      end


  def get_request
  	id = params[:vendor_request][:request_id]
  	@request = Request.find_by(:id => id)
  	@vendor_request = VendorRequest.find_by(:request_id => id,:status => ['Waiting','Accepted','Finished'])
  	@retailers = Retailer.find_by(:retailer_code => Request.where(:id => id).pluck(:retailer_code))
  	@cmo = CMO.find_by(:id => @request.cmo_id)
    map = {}
    map[:shop_name] = @retailers.retailer_name
    map[:retailer_code] = @retailers.retailer_code
    map[:state] = @retailers.state
    map[:city] = @retailers.city
    map[:request_id] = id
    map[:request_type] = @request.request_type.upcase
    map[:request_status] = @vendor_request.status
    map[:assigned_date] = @vendor_request.assigned_date
    
    if @retailers.contact_person == nil || @retailers.contact_person == ''
      map[:retailer_name] = @retailers.retailer_name
    else
      map[:retailer_name] = @retailers.contact_person
    end

    if @retailers.mobile_number == nil || @retailers.mobile_number == ''
      map[:mobile_number] = ' '
    else
      map[:mobile_number] = @retailers.mobile_number
    end
    
    map[:cmo_name] = @cmo.name
    
    @vendor_request = VendorRequest.find_by(:request_id => id,:status => ['Waiting','Accepted','Finished'])
    @vendor_stages = @vendor_request.vendor_stages
    if @vendor_stages == nil || @vendor_stages == ''
      map[:decline_button] = 'enable'
    else
      vendor_stages = @vendor_stages.pluck(:stage_name)
      if vendor_stages.include? 'request_accept'
        map[:decline_button] = 'disable'
      else
        map[:decline_button] = 'enable'
      end
    end
    stage_name = @vendor_stages.pluck(:stage_name)
    render :json => {:request => map}
  end

  def get_request_status
  	id = params[:vendor_request][:request_id]
  	@request = Request.find_by(:id => id)
  	@vendor_request = VendorRequest.find_by(:request_id => id,:status => ['Waiting','Accepted','Finished'])
  	vendor_response = @vendor_request.vendor_response
    @vendor_stages = @vendor_request.vendor_stages
    vendor_stage_array = @vendor_stages.pluck(:stage_name)
    all_stage_array = ['request_accept','shop_visit','estimate_shared','po_received','in_production','in_transit','installation_complete','bill_received']
    map = {}
    enable_stage_index = '';
    all_stage_array.each_with_index do |all_stage,index|
      if vendor_stage_array.include? all_stage
          map["#{all_stage}"] = 'checked'
          enable_stage_index = index+1
      else
          map["#{all_stage}"] = 'disable'
      end
    end

    enable_key = all_stage_array[enable_stage_index.to_i]
    map["#{enable_key}"] = 'enable'
    render :json => {:request => map}		
  end

  def accept_request
    id = params[:vendor_request][:request_id]
    date = Date.today
    @vendor_request = VendorRequest.find_by(:request_id => id,:status => 'Waiting')
    @update_request = VendorStage.new(:stage_name => 'request_accept',:update_date => date,:vendor_request_id => @vendor_request.id)
    if @update_request.save
       @vendor_request.status = 'Accepted'
       @vendor_request.vendor_response = 'Request Accepted'
       @vendor_request.save
       render :json => {:result => true}
    else
       render :json => {:result => false,:message => 'Updation failed, try again'}
    end

  end

  def reject_request
    id = params[:vendor_request][:request_id]
    date = Date.today
    @vendor_request = VendorRequest.find_by(:request_id => id,:status => 'Waiting')
    @update_request = VendorStage.new(:stage_name => 'rejected',:update_date => date,:vendor_request_id => @vendor_request.id)
    if @update_request.save
       @vendor_request.status = 'Rejected'
       @vendor_request.vendor_response = 'Request Rejected'
       @vendor_request.save
       render :json => {:result => true}
    else
       render :json => {:result => false,:message => 'Updation failed, try again'}
    end
  end


  def update_request_status
    id = params[:vendor_request][:request_id]
    date = Date.today
    map = params[:vendor_request]
    map.each_with_index do |key|
      if key[1] == 'true'
          @vendor_request = VendorRequest.find_by(:request_id => id,:status => ['Waiting','Accepted'])
          @update_request = VendorStage.new(:stage_name => key[0],:update_date => date,:vendor_request_id => @vendor_request.id)
          @update_request.save
        if key[0] == 'bill_received'
          @vendor_request.status = 'Finished'
          @vendor_request.save
        end
          @vendor_request.vendor_response = key[0].camelize
          @vendor_request.save    
      end
    end
    render :json => {:result => true}
  end

end
end
end