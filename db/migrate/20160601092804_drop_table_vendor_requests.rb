class DropTableVendorRequests < ActiveRecord::Migration
  def change
  	drop_table :vendor_requests
  end
end
