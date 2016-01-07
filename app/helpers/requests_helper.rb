module RequestsHelper

	def shop_branding_details(start_date,end_date,state)
		if state == nil || state.length == 0 || state == 'All'
			 @state = Retailer.order(:state).all.map {|a| [a.state]}.uniq
		else
			 @state = state.split(',')
		end
		t = []
		TYPE.each do |rtype|
			data = []		
			type = {}
			type[:request_type] = rtype
		    states = {}		
		    type_request = find_request_by_request_type(request_type(rtype))			    
			@state.each do |state|
				@stat = {}
				if state.kind_of?(Array)
				  @stat[:state] = state.join(',')
				else
				  @stat[:state] = state
				end
				state_request = find_request_by_state(type_request,state)
				date_request = find_request_by_date(state_request,start_date,end_date)										
				STAT.each do |status|
					status_request = find_request_by_status(date_request,status)				
					@stat[status] = status_request.length					
				end
				@stat[:fixed] = 0
				@stat[:acheived] = 0
				@stat[:in_transit] = 0
				@stat[:audited] = 0
				data.push(@stat)
			    type[:data] = data
						
			end
			t.push(type)
		end	
		t
	end

	def shop_list_details(start_date,end_date,request_type,states)
		type = []
		type_request = find_request_by_request_type(request_type(request_type))
		date_request = find_request_by_date(type_request,start_date,end_date)
		@states = state(states)
		@states.each do |state|
			@stat = {}
			@stat[:state] = state
		    state_request = find_request_by_state(date_request,state)
		    STAT.each do |status|
					status_request = find_request_by_status(state_request,status)				
					status_request.each do |request|
					   @stat[:id] = request.id	
					   @stat[:date] = request.created_at
					   retailer = find_shop_by_retailer(request.retailer_code)
					   @stat[:shop_name] = retailer.retailer_name
					   @stat[:status] = request.status.camelize
					   type.push(@stat)
					end			
			end
		end
		type
	end

	def request_details(id)
		type = {}
		request = Request.find(id)
		retailer = find_shop_by_retailer(request.retailer_code)
		beatroute = Beatroute.find_by(:retailer_code => request.retailer_code,:created_at => request.created_at.prev_month..request.created_at)
		type[:retailer_code] = retailer.retailer_code
		type[:shop_name] = retailer.retailer_name
		type[:contact_person] = retailer.contact_person
		type[:address] = retailer.address
		type[:vol_sale] = beatroute.mtd_avg_sales_volume
		type[:last_month_sale] = beatroute.last_month_avg_sales_volume
		type[:last_month_average_sale] = request.avg_gionee_monthly_sales
		if Request.find_by(:retailer_code == request.retailer_code,:request_type => 4)
		  type[:audited] = 'Yes'
		else
		  type[:audited] = 'No'
		end
		type
	end

	def find_shop_by_retailer(retailer_code)
		Retailer.find_by(:retailer_code => retailer_code)
	end


    def find_request_by_state(request,state)
    	request.where(:state => state)
    end

    def find_request_by_request_type(request_type)
    	Request.where(:request_type => request_type)
    end

    def find_request_by_date(request,start_date,end_date)
    	request.where(:created_at => start_date..end_date)
    end

    def find_request_by_status(request,status)
    	if status == 'pending'
    		@request = request.where(:status => ['cmo_pending','pending'])
    	elsif status == 'declined'
    		@request = request.where(:status => ['cmo_declined','declined'])
    	else
    		@request = request.where(:status => status)
    	end	
    	@request
    end

	def request_type(type)
		case type
		when 'all','All'	
			[0,1,2,3,4]
		when 'gsb','GSB'
			0
		when 'sis','SIS'
			1
		when 'in_shop','IN_SHOP'
			2
		when 'maintenance','MAINTENANCE'
			3
		when 'visitor','VISITOR'
			4
		end
	end

	def state(value)
			if value == 'all' || value == 'All' || value == 'ALL'
				Retailer.order(:state).all.map {|a| [a.state]}.uniq
			else
				value.split(',')
			end	
	end

	def cmo_id(id,role)
		if role.include?('cmo')
		 user = User.find_by(:id => id)
	     email = user.email
	     cmo = CMO.find_by(:email => email)
	     cmo_id = cmo.id
	    else
	    	 ''
	    end
	end

	def request_data(id)
		Request.find_by(:id => id)
	end

	def requests_search(role,type,id,request_type,current_user)
                if type == 'Request Id'
                	if request_type.include?('0')
                		if request_data(id).request_type == 'sis' || request_data(id).request_type == 'in_shop' || request_data(id).request_type == 'gsb'
		                    "/requests/#{id}/edit"
		                end
		            elsif request_type.include?('3')   
		            	if request_data(id).request_type == 'maintenance'
		                    "/requests/#{id}/edit"
		                end
		            elsif request_type.include?('4')
		                if request_data(id).request_type == 'visitor'
		                    "/requests/#{id}/edit"
		                end 
                    end
                elsif type == 'RetailerCode'
                	if request_type.include?('0')
                		if role.include?('cmo')|| role.include?('supercmo')
                			"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end
                	elsif request_type.include?('3')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=3&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=3&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end
                	elsif request_type.include?('4')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=4&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=4&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end	
                	end	
                elsif type == 'State'
                	if request_type.include?('0')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end
                	elsif request_type.include?('3')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=3&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=3&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end
                	elsif request_type.include?('4')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=4&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=4&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end				
                	end		
			    end        
			 
	    
    end  

end