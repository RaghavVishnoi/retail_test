class UpdateColumnSizeShopAddress < ActiveRecord::Migration
  def change
  	change_column :requests,:shop_address,:text
  end
end
