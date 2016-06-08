class AddColumnToRequestAssignment < ActiveRecord::Migration
  def change
    add_column :request_assignments, :priority, :string
  end
end
