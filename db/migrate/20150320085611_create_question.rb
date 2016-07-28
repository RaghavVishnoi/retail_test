class CreateQuestion < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.text :content
      t.integer :question_type
      t.timestamps
    end
    add_index :questions, :survey_id
  end
end
