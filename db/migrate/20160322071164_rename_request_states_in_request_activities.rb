class RenameRequestStatesInRequestActivities < ActiveRecord::Migration
  def change
  	rename_column :request_activities,:request_states,:request_status
  end
end
