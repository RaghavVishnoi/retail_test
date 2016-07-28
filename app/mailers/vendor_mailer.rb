class VendorMailer < ActionMailer::Base
  default from: "akash@gionee.co.in"

  def vendor_assignment(vendorlist,assigned_request_list)
  	subject = "Assigned Requests"
  	@requests = assigned_request_list
  	request_type =  Request.where(:id => @requests).pluck(:request_type)
	  @retailer_code = Request.where(:id => @requests).pluck(:retailer_code)
    @retailers = Retailer.where(:retailer_code => @retailer_code)
    @request_type = []
    request_type.each do |type|
    	if type == 0
    		@request_type.push('GSB')
    	elsif type == 1
    		@request_type.push('SIS')
    	elsif type == 2
    		@request_type.push('In Shop')
    	elsif type == 3
    		@request_type.push('Maintenance')
    	elsif type == 4
    		@request_type.push('Audit')
    	end
    			
    end
	 
  	mail(to: vendorlist.email,subject: subject )
  end

end
