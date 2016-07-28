class AddColumnsToScreens < ActiveRecord::Migration
  def change
    add_column :screens, :module_group_id, :integer
    add_column :screens, :is_start_screen, :boolean, :default => false
  end
end
