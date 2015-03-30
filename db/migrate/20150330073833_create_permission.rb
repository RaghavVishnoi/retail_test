class CreatePermission < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :role_id
      t.string :action
      t.string :subject_class
      t.timestamps
    end
    add_index :permissions, :role_id
  end
end
