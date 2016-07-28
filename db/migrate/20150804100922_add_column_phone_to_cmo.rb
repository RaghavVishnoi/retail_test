class AddColumnPhoneToCmo < ActiveRecord::Migration
  def change
  	add_column :cmos, :phone, :string
  end
end
