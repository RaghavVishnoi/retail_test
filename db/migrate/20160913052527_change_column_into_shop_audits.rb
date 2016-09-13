class ChangeColumnIntoShopAudits < ActiveRecord::Migration
  def change
  	change_column :shop_audits,:sis_type_logo,:text
  	change_column :shop_audits,:posters_models,:text
  	change_column :shop_audits,:sticker_models,:text
  	change_column :shop_audits,:brochure_models,:text
  	change_column :shop_audits,:leaflet_models,:text
  	change_column :shop_audits,:back_wall_model,:text
  	change_column :shop_audits,:lit_standee_models,:text
  	change_column :shop_audits,:countertop_models,:text
  	change_column :shop_audits,:demo_models,:text
  	change_column :shop_audits,:clipon_models,:text
  	change_column :shop_audits,:dummy_models,:text
  end
end
