class Beatroute < ActiveRecord::Base

    # validates :retailer_name,:retailer_code, :presence => true


	def self.single_record(id)
		Beatroute.find_by(:id => id)
	end

	def self.save(upload)
	    name =  upload.original_filename
	    directory = "public/uploads/beatroute/upload"
	    # create the file path
	    string = upload.original_filename.partition(".").last
	    
	    if string == 'csv' || string == 'CSV'
	    	csv = CSV.read(upload.path, headers: false)
	    	header = csv[0]
	    	if header[0].upcase == 'Distributor Name'.upcase && header[1].upcase == 'TSM Name'.upcase && header[2].upcase == 'RSP Name'.upcase && header[3].upcase == 'RSP ID'.upcase && header[4].upcase == 'Employee Code'.upcase && header[5].upcase == 'BeatRoute Shop Code'.upcase && header[6].upcase == 'Zed Sales Shop Code'.upcase && header[7].upcase == 'Retailer Name'.upcase && header[8].upcase == 'City'.upcase && header[9].upcase == 'Last Month Avg Sales Volume'.upcase && header[10].upcase == 'Last Month Avg Sales Value'.upcase && header[11].upcase == 'MTD Avg Sales Volume'.upcase && header[12].upcase == 'MTD Avg Sales Value'.upcase && header[13].upcase == 'Avg Last Month Attendance Days'.upcase && header[14].upcase == 'Last Reported Stock - Number'.upcase && header[15].upcase == 'Models In stock'.upcase && header[16].upcase == 'Distance between Beatroute and APP locations'.upcase && header[17].upcase == 'SIS Type'.upcase && header[18].upcase == 'Installed on'.upcase && header[19].upcase == 'GSB Type'.upcase && header[20].upcase == 'Installed on'.upcase && header[21].upcase == 'Clipon'.upcase && header[22].upcase == 'Countertop'.upcase && header[23].upcase == 'Flange'.upcase && header[24].upcase == 'Standee'.upcase && header[25].upcase == 'Inshop Branding'.upcase && header[26].upcase == 'SIS'.upcase && header[27].upcase == 'GSB'.upcase
	    		path = File.join(directory, name)
	            File.open(path, "wb") { |f| f.write(upload.read) }
	            @file = UploadFile.new
	            @file.file_name = upload.original_filename
	            @file.uploaded_on = Time.now
	            @file.type = 'Beatroute'
	            @file.status = 'Pending'
	            @file.save
	            'success'
	    	else
	    		'wrong_format'
	    	end	
	    	
	    else
	    	'failure'
	    end
	end

	def self.insert_records
		@upload_files = UploadFile.where(:type => 'Beatroute',:status => 'Pending')
		@upload_files.each do |upload_files|
			csv = CSV.read('public/uploads/beatroute/upload/'+upload_files.file_name,headers: true)
			csv.each_with_index do |row,index|
				 @beatroute = Beatroute.new
				 @beatroute.distributor_name = row[0]
				 @beatroute.tsm_name = row[1]
				 @beatroute.rsp_name = row[2]
				 @beatroute.rsp_id = row[3]
				 @beatroute.employee_code = row[4]
				 @beatroute.shop_code = row[5]
				 @beatroute.retailer_code = row[6]
				 @beatroute.retailer_name = row[7]
				 @beatroute.city = row[8]
				 @beatroute.last_month_avg_sales_volume = row[9]
				 @beatroute.last_month_avg_sales_value = row[10]
				 @beatroute.mtd_avg_sales_volume = row[11]
				 @beatroute.mtd_avg_sales_value = row[12]
				 @beatroute.avg_last_month_attendance = row[13]
				 @beatroute.last_reported_stock = row[14]
				 @beatroute.models_in_stock = row[15]
				 @beatroute.distance_btwn_beatroute_and_app_location = row[16]
				 @beatroute.sis_type = row[17]
				 @beatroute.sis_installed_on = row[18]
				 @beatroute.gsb_type = row[19]
				 @beatroute.gsb_installed_on = row[20]
				 @beatroute.clipon = row[21]
				 @beatroute.countertop = row[22]
				 @beatroute.flange = row[23]
				 @beatroute.standee = row[24]
				 @beatroute.inshop_branding = row[25]
				 @beatroute.sis = row[26]
				 @beatroute.gsb = row[27]
				 @beatroute.created_at = Time.Now
				 if @beatroute.save
				 	begin
					  @upload_file = UploadFile.where(:id => upload_files.id).update_all(status: 'Uploaded',inserted_on: Time.now)
					  File.rename('public/uploads/beatroute/upload/'+upload_files.file_name, 'public/uploads/beatroute/uploaded/'+upload_files.file_name+'_'+upload_files.uploaded_on.to_s)
					  UploadFileMailer.delay.upload_confirmation
					  'success'
					rescue

					end
				 else
				 	  'failure'
				 end

			end	
		end	
	end

end
