class AddVendorRequestFkInVendorStages < ActiveRecord::Migration
  def change
  	add_column :vendor_stages, :vendor_request_id, :integer
    add_index :vendor_stages, :vendor_request_id
  end
end
