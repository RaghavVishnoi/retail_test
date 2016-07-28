class CreateCatchmentBusinessShops < ActiveRecord::Migration
  def change
    create_table :catchment_business_shops do |t|
    	t.string :left
    	t.string :right
    	t.string :opposite
    	 
    end
    add_reference :catchment_business_shops, :catchment, index: true, foreign_key: true
  end
end
