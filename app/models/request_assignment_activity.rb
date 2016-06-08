class RequestAssignmentActivity < ActiveRecord::Base

	belongs_to :request_assignment
	belongs_to :user

	validates :request_assignment_id, presence: true
	validates :user_id, presence: true
	validate  :message

end