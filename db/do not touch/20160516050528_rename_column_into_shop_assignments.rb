class RenameColumnIntoShopAssignments < ActiveRecord::Migration
  def change
  	rename_column :shop_assignments,:type,:assignment_type
  end
end
