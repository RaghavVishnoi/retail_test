class ChangeRequestTypeToInteger < ActiveRecord::Migration
  def change
    #change_column :requests, :request_type, :integer
    change_column :requests, :request_type, 'integer USING CAST(request_type AS integer)'

    add_index :requests, :request_type
  end
end
