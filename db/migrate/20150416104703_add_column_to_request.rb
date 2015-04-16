class AddColumnToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :type_of_sis_required, :string
    add_column :requests, :space_available, :string
    add_column :requests, :type_of_gsb_requested, :string
  end
end
