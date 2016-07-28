class RenameTypeInShopOwnership < ActiveRecord::Migration
  def change
  	rename_column :shop_ownerships, :type, :shop_type

  end
end
