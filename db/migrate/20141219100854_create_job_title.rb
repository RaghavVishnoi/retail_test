class CreateJobTitle < ActiveRecord::Migration
  def change
    create_table :job_titles do |t|
      t.string :title
    end
  end
end
