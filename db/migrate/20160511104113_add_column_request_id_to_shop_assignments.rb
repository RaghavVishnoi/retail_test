class AddColumnRequestIdToShopAssignments < ActiveRecord::Migration
  def change
  	add_reference :shop_assignments,:request,index: true
  end
end
