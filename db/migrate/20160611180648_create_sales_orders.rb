class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
    	t.string :name
    	t.string :email
    	t.string :phone
    	t.text :comment
    	t.string :status
    	t.timestamps null: false
    end
    add_reference :sales_orders, :state, index: true, foreign_key: true

  end
end
