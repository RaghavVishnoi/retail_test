class AddSuggestedColumnsIntoShopAudits < ActiveRecord::Migration
  def change
  	add_column :shop_audits,:sis_type_logo,:string,limit: 5
  	add_column :shop_audits,:posters_models,:string,limit: 25
  	add_column :shop_audits,:sticker_models,:string,limit: 25
  	add_column :shop_audits,:brochure_models,:string,limit: 25
  	add_column :shop_audits,:leaflet_models,:string,limit: 25
  	add_column :shop_audits,:back_wall_model,:string,limit: 25
  end
end
