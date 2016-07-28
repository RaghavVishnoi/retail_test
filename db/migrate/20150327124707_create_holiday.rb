class CreateHoliday < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :description
      t.string :timezone
      t.date :date
      t.timestamps
    end
  end
end
