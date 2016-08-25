class AddColumnSalesChannelCodeIntoRetailers < ActiveRecord::Migration
  def change
  	add_column :retailers,:sales_channel_code,:string,after: :sales_channel
  end
end
