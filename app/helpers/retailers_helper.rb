module RetailersHelper
	require 'httparty'
	require 'rubygems'
    require 'geokit'
	
	def zedsales_upload(begin_time,end_time)
		syncCount = 0
		param1 = ZED_SALES_PARAMS[0]
		param2 = ZED_SALES_PARAMS[1]
		url = ZED_SALES_URL[0]+'&'+param1+'='+begin_time+'&'+param2+'='+end_time
		response = HTTParty.get(url)
		json = JSON.parse(response.body)
		if json[0].values[0] != 0
		    retailers_data = json[0].values[1]
		    retailers_data.each do |data|
		    	retailer_code = data['RetailerCode']
		    	if Retailer.exists?(:retailer_code => retailer_code)
		    		syncCount = syncCount + 1
		    		update_retailer(data)
		    	else
		    		syncCount = syncCount + 1
		    		create_retailer(data)
		    	end
		    end
		end 
		SyncService.create!(name: 'Retailer',url: url,sync_time: Time.now,start_time: begin_time,end_time: end_time,sync_count: syncCount)    	   	
		syncCount
	end

	def update_retailer(data)
		if data['Status'] == '1'
			@status =  "Active"
		else
			@status =  "Inactive"
		end
		retailer = Retailer.find_by(:retailer_code => data['RetailerCode'])
		 
		if retailer.latitude == 0.0 || retailer.longitude == 0.0 || retailer.latitude == nil || retailer.longitude == nil		  
			lat = 0.0;long=0.0;
			begin
				lat_long=Geokit::Geocoders::GoogleGeocoder.geocode retailer.address
				lat = lat_long.ll.split(',')[0]
	        	long = lat_long.ll.split(',')[1]  
        	rescue
        	end
        else
        	lat = retailer.latitude
        	long = retailer.longitude
    	end
		
		retailer.update(:retailer_name => data['RetailerName'],:retailer_code => data['RetailerCode'],:sales_channel => data['SalesChannelName'],:contact_person => data['ContactPerson'],:state => data['StateName'],:city => data['CityName'],:pincode => data['PinCode'],:tin_number => data['TinNumber'],:mobile_number => data['MobileNumber'],:status => @status,:is_isp_on_counter => '',:counter_size => data['CounterSize'],:nd => data['ND'],:address => data['RetailerAddress'],:location_code => data['MUMCode'],:salesman_id => data['SalesmanID'],:latitude=> lat,:longitude=>long,:sales_channel_code => data['SalesChannelCode'],email: data['Email'] )
	end

	def create_retailer(data)
		if data['Status'] == '1'
			@status =  "Active"
		else
			@status =  "Inactive"
		end
		lat = 0.0;long=0.0;
		begin
			lat_long=Geokit::Geocoders::GoogleGeocoder.geocode data['RetailerAddress']
			lat = lat_long.ll.split(',')[0]
	        long = lat_long.ll.split(',')[1] 
        rescue

        end 

		Retailer.create(:retailer_name => data['RetailerName'],:retailer_code => data['RetailerCode'],:sales_channel => data['SalesChannelName'],:contact_person => data['ContactPerson'],:state => data['StateName'],:city => data['CityName'],:pincode => data['PinCode'],:tin_number => data['TinNumber'],:mobile_number => data['MobileNumber'],:status => @status,:is_isp_on_counter => '',:counter_size => data['CounterSize'],:nd => data['ND'],:address => data['RetailerAddress'],:location_code => data['MUMCode'],:salesman_id => data['SalesmanID'],:latitude=> lat,:longitude=>long,:sales_channel_code => data['SalesChannelCode'],email: data['Email'])
	end
end
