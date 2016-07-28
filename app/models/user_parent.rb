class UserParent < ActiveRecord::Base

	belongs_to :user

	validates :parent_id,presence: true
	validates :user_id,presence: true
	validates :role,presence: true

	def self.children(parent_id,role)
		children_ids = self.where(parent_id: parent_id,role: role).pluck(:user_id)
		User.where(id: children_ids)
	end

	def self.user_parent(child_id,role)
		parent_ids = self.where(user_id: child_id,role: role).pluck(:parent_id)
		User.where(id: parent_ids)
	end

	def self.user_parent_id(child_id,role)
		parent_ids = self.where(user_id: child_id,role: role).pluck(:parent_id)
		user = User.where(id: parent_ids).pluck(:id)
	end

end
