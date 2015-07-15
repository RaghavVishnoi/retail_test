class CreateVendorTasks < ActiveRecord::Migration
  def change
    create_table :vendor_tasks do |t|

    t.string :retailer_code
    t.string :request_id
    t.text :comment	
      t.timestamps
    end
  end
end
