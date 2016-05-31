class AddColumnIntoShopAssignments < ActiveRecord::Migration
  def change
  	add_column :shop_assignments,:type,:integer,:default => 1
  end
end
