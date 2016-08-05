class CreateParteners < ActiveRecord::Migration
  def change
    create_table :parteners do |t|
    	t.string :structure
    	t.string :ownership
    	t.string :nature
    	t.string :turnover
    	t.string :man_power
    	t.string :partener_name
    	t.text :breif_intro
    end
    add_reference :parteners, :sales_order, index: true, foreign_key: true
  end
end
