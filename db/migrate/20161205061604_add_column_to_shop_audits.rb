class AddColumnToShopAudits < ActiveRecord::Migration
  def change
  	add_column :shop_audits,:gionee_position,:string,:limit => 2
  	rename_column :shop_audits,:back_wall_model,:back_wall_models
  end
end
