class CreateAlcoholPercent < ActiveRecord::Migration
  def change
    create_table :alcohol_percents do |t|
      t.string :value
      t.timestamps
    end
  end
end
