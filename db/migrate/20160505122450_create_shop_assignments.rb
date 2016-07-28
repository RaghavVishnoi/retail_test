class CreateShopAssignments < ActiveRecord::Migration
  def change
    create_table :shop_assignments do |t|
    	t.datetime :assign_date
    	t.string :status,default: 'pending'
        t.timestamps
    end
    add_reference :shop_assignments,:user,index: true
    add_reference :shop_assignments,:retailer,index: true
  end
end
