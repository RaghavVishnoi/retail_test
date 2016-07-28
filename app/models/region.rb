class Region < ActiveRecord::Base
  include Fields
  
  has_and_belongs_to_many :users
  has_many :data_files_regions
  has_many :regions, :through => :data_files_regions
  
  validates :name, :presence => true
end