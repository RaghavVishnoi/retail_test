class AddUpdatedAtToScreen < ActiveRecord::Migration
  def change
    add_column :screens, :created_at, :datetime
    add_column :screens, :updated_at, :datetime
  end
end
