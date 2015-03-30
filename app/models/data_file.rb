class DataFile < ActiveRecord::Base
  acts_as_nested_set

  mount_uploader :data_file, DataFileUploader

  validates :name, :presence => true
  
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :associated_roles, :as => :object, :dependent => :destroy
  has_many :roles, :through => :associated_roles
  has_many :data_files_users
  has_many :users, :through => :data_files_users
  has_many :data_files_regions
  has_many :regions, :through => :data_files_regions

  def self.with_parent_id(parent_id)
    where(:parent_id => parent_id)
  end

  def self.accessible_by(user)
    (with_user_id(user.id) + with_roles(user.role_ids) + with_user_ids(user.id) + with_regions(user.region_ids)).uniq
  end

  def self.with_user_id(user_id) 
    where(:user_id => user_id)
  end

  def self.with_roles(role_ids)
    joins(:associated_roles).where(:associated_roles => { :role_id => role_ids })
  end

  def self.with_regions(region_ids) 
    joins(:data_files_regions).where(:data_files_regions => { :region_id => region_ids })
  end

  def self.with_user_ids(user_id)
    joins(:data_files_users).where(:data_files_users => { :user_id => user_id })
  end

  def accessible_by?(user)
    user_id == user.id || associated_roles.exists?(:role_id => user.role_ids) || (data_files_users.exists?(:user_id => user.id)) || (data_files_regions.exists?(:region_id => user.region_ids))
  end

  def user_ids_string=(str)
    self.user_ids = str.split(',')
  end

  def user_ids_string
    user_ids
  end
end