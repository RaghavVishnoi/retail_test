class CreateModuleGroup < ActiveRecord::Migration
  def change
    create_table :module_groups do |t|
      t.integer :name
      t.boolean :active
    end
  end
end
