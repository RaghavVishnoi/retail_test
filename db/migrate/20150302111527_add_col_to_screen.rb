class AddColToScreen < ActiveRecord::Migration
  def change
    add_column :screens, :is_menu, :boolean, :default => false
  end
end
