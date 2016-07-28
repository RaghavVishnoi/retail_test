class CreateSurvey < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :heading
      t.timestamps
    end
  end
end
