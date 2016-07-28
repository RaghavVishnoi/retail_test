class CreateBizs < ActiveRecord::Migration
  def change
    create_table :bizs do |t|
    	t.string :title
    	t.string :month1
    	t.string :month2
    	t.string :month3
    	t.string :month4
    	t.string :month5
    	t.string :month6
    	t.string :month7
    	t.string :month8
    	t.string :month9
    	t.string :month10
    	t.string :month11
    	t.string :month12
      t.timestamps 	null: false
    end
    add_reference :bizs, :sales_order, index: true, foreign_key: true

  end
end
