class ChangeRequestIdInVendorRequests < ActiveRecord::Migration
  def change
  	change_column :vendor_requests, :request_id, :integer, :null => false
  	change_column :vendor_requests, :vendor_id, :integer, :null => false
  end
end
