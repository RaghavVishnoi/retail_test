class AddColumnsToRequestAssignment < ActiveRecord::Migration
  def change
    add_column :request_assignments, :is_rrm, :boolean
    add_column :request_assignments, :is_valc, :boolean
  end
end
