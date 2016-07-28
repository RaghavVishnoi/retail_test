class CreateFieldValue < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.integer :field_id
      t.integer :resource_id
      t.string :resource_type
      t.string :value
      t.timestamps
    end
  end
end
