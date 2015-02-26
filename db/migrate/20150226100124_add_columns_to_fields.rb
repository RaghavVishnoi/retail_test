class AddColumnsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :field_type, :integer
    add_column :fields, :configuration, :text
    add_column :fields, :value_type, :integer
  end
end
