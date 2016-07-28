class CreateJobTitlesUsers < ActiveRecord::Migration
  def change
    create_table :job_titles_users do |t|
      t.integer :user_id
      t.integer :job_title_id
    end
  end
end
