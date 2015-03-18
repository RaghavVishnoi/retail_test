class CreateUsersReporting < ActiveRecord::Migration
  def change
    create_table :users_reportings do |t|
      t.integer :reporting_user_id
      t.integer :report_to_user_id
    end
    add_index :users_reportings, :reporting_user_id
    add_index :users_reportings, :report_to_user_id
    add_index :users_reportings, [:reporting_user_id, :report_to_user_id], :name => "reporting_users_and_report_to_users"
  end
end
