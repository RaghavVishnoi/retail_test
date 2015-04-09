class AddMandatoryToField < ActiveRecord::Migration
  def change
    add_column :fields, :mandatory, :boolean, :default => false
  end
end
