class CreateSize < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.string :name
      t.timestamps
    end
  end
end
