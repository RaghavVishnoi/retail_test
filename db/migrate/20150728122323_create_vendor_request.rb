class CreateVendorRequest < ActiveRecord::Migration
  def change
    create_table :vendor_requests do |t|
    	t.integer :vendor_id
    	t.integer :request_id
    	t.date :assigned_date
    	t.string :vendor_response
    	t.date :vendor_response_date
    	t.string :status
    	t.string :description
    end
  end
end
