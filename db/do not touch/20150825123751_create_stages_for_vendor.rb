class CreateStagesForVendor < ActiveRecord::Migration
  def change
    create_table :vendor_stages do |t|
    	t.string :stage_name
    	t.date :update_date
    	t.timestamps
    end

  end
end
