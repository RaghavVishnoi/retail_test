class CreateCatchments < ActiveRecord::Migration
  def change
    create_table :catchments do |t|
    	t.text :introduction
    	t.integer :population
    	t.text :colonies
    	t.text :brand_stores
    	t.text :consumer_stores
    	t.integer :rsp_counters
    	t.integer :sis_counters
    	 
    end
    add_reference :catchments, :sales_order, index: true, foreign_key: true
  end
end
 