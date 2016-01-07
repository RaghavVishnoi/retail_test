class Retailer < ActiveRecord::Base
	 
	validates :retailer_code, :presence => true, :uniqueness => {:message => "Retailer code can't be duplicate"}
	validates :retailer_name,:address,:state,:city,:status, :presence => {:message => "Some Values are required"}
    validate :mobile_number


def self.search(id)
    @retailer = Retailer.where("retailer_code = ? OR state = ? OR city = ?", id,id,id) 
end

def self.new_retailers(upload)
	@new_retailers = []
	file = File.open("public/uploads/retailer/upload/"+upload.id.to_s+"/"+upload.file_name.to_s+"_new", "r")
	file.each_line do |line|
       line = line.strip.split ','
       @new_retailers = line.to_s
    end
    @new_retailers
end

def self.update_retailers(upload)
	@update_retailers = []
	file = File.open("public/uploads/retailer/upload/"+upload.id.to_s+"/"+upload.file_name.to_s+"_update", "r")
	file.each_line do |line|
       line = line.strip.split ','
       @update_retailers = line.to_s
    end
    @update_retailers
end

def self.insert_data(new_retailers_array,update_retailers,url,upload)

  columns = Retailer.column_names
  @new_retailers_array = new_retailers_array
   # string = file.original_filename.partition(".").last
   workbook = Roo::Spreadsheet.open(url, extension: '.xlsx')
   columns = Retailer.column_names 
   begin

	   workbook.each_with_pagename  do |name, sheet|
		   	sheet.each_with_index  do |row,index|
		   		 unless index < 1
 							
			   	 		if @new_retailers_array.include? row[1] 
			   	 			@file_read = Retailer.new
							 (1...columns.length-2).each do |column_count|
					   	 	   	    if columns[column_count] == 'retailer_code'
						   	 	  	    @file_read["#{columns[column_count]}"] = row[column_count-1].strip
						   	 	  	else
						   	 	  		@file_read["#{columns[column_count]}"] = row[column_count-1]
						   	 	  	end
					   	 	   end 
				            @file_read.save
				        end
			   	 end
		   	end
		   			
		   	if update_retailers.size != 0
			    retailers_array = update_retailers
			    update_retailer = Retailer.where( retailer_code: retailers_array ).update_all( status: 'Inactive' )
			end
	   end
	  @upload_file = UploadFile.where(:id => upload.id).update_all(status: 'Uploaded',inserted_on: Time.now)
	  require 'fileutils'
	  FileUtils.remove_dir "public/uploads/retailer/upload/#{upload.id}", true
	  UploadFileMailer.delay.upload_retailer_confirmation
	  'success'
	  rescue => exception
	  	exception
	  end 				  
 end

def self.file_to_upload
	UploadFile.where(:type => 'Retailer',:status => 'Pending')
end

def self.display_names
    all.map { |c| [c.display_name, c.id] }
end

def display_name
    name = Retailer.select(:state).uniq
end



  
	 
end
