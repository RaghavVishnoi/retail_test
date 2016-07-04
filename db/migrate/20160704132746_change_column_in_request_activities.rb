class ChangeColumnInRequestActivities < ActiveRecord::Migration
  def change
  	change_column :request_documents,:request_document_id,:integer
  end
end
