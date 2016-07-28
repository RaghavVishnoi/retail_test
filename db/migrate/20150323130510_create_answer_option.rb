class CreateAnswerOption < ActiveRecord::Migration
  def change
    create_table :answer_options do |t|
      t.integer :answer_id
      t.integer :question_option_id
    end
    add_index :answer_options, :answer_id
  end
end
