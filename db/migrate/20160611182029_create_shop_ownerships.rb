class CreateShopOwnerships < ActiveRecord::Migration
  def change
    create_table :shop_ownerships do |t|
    	t.string :type
    	t.string :title
    	t.string :clear_title_duration
    	t.string :parking_available
    	t.string :hindrance_entrance
    	 
    end
    add_reference :shop_ownerships, :sales_order, index: true, foreign_key: true
  end
end
