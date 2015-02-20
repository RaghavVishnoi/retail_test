class DataFile < ActiveRecord::Base
  acts_as_nested_set

  mount_uploader :data_file, DataFileUploader

  include RoleModel

  roles :superadmin, :admin, :manager, :user

  validates :name, :presence => true
  
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :data_files_users
  has_many :users, :through => :data_files_users
  has_many :data_files_regions
  has_many :regions, :through => :data_files_regions

  def self.with_parent_id(parent_id)
    where(:parent_id => parent_id)
  end

  def self.accessible_by(ability)
    select { |file| ability.can?(:read, file) }
  end

  def accessible_by?(user, search_in_hierarchy=true)
    user_id == user.id || has_any_role?(user.roles.to_a) || (data_files_users.exists?(:user_id => user.id)) || (data_files_regions.exists?(:region_id => user.region_ids)) || (search_in_hierarchy && ((descendants + ancestors).any? { |file| file.accessible_by?(user, false) }))
  end

  def user_ids_string=(str)
    self.user_ids = str.split(',')
  end

  def user_ids_string
    user_ids
  end

end