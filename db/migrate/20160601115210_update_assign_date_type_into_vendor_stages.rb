class UpdateAssignDateTypeIntoVendorStages < ActiveRecord::Migration
  def change
  	change_column :vendor_stages,:update_date,:datetime
  end
end
