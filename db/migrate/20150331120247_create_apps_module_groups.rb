class CreateAppsModuleGroups < ActiveRecord::Migration
  def change
    create_table :apps_module_groups do |t|
      t.integer :app_id
      t.integer :module_group_id
      t.timestamps
    end
  end
end
