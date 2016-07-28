class CreateCustomer < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :state
      t.string :phone_number
      t.string :store_manager
      t.string :avatar
    end
  end
end
