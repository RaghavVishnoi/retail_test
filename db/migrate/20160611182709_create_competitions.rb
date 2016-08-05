class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
    	t.string :name
    	t.string :comp_name
    	t.string :comp_value
     end
    add_reference :competitions, :sales_order, index: true, foreign_key: true
  end
end
