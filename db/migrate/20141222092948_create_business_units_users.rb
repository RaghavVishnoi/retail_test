class CreateBusinessUnitsUsers < ActiveRecord::Migration
  def change
    create_table :business_units_users do |t|
      t.integer :business_unit_id
      t.integer :user_id
    end
  end
end
