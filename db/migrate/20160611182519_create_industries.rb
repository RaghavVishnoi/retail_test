class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
    	t.string :name
    	t.string :value
    	t.string :volume
    	t.string :comp_name
    	t.string :comp_value
     end
    add_reference :industries, :sales_order, index: true, foreign_key: true
  end
end
