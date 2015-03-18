class ModifyCustomers < ActiveRecord::Migration
  def change
    drop_table :customers
    create_table :customers do |t|
      t.string :name
      t.string :customer_type
      t.string :website
      t.string :account_owner
      t.integer :parent_customer_id
      t.string :phone
      t.string :industry
      t.string :customer_group
      t.string :description
      t.string :phone1
      t.string :phone2
      t.string :email1
      t.string :email2
      t.text :licence_details
      t.timestamps
    end
  end
end