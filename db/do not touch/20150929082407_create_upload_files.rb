class CreateUploadFiles < ActiveRecord::Migration
  def change
    create_table :upload_files do |t|
    	t.string :file_name
    	t.datetime :uploaded_on
    	t.datetime :inserted_on
    	t.string :type
    	t.string :status
    	t.timestamps
      
    end
  end
end
