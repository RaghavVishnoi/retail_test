class UploadFile < ActiveRecord::Base
	self.table_name = 'upload_files'
	self.inheritance_column = nil
end
