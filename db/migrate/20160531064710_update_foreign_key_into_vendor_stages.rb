class UpdateForeignKeyIntoVendorStages < ActiveRecord::Migration
  def change
  	remove_column :vendor_stages,:vendor_request_id
  	add_reference :vendor_stages,:request_assignment
  end
end
