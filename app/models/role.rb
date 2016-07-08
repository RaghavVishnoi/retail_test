class Role < ActiveRecord::Base
  has_many :associated_roles, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
 
  validates :name, :presence => true

  def self.role_name(role_ids)
  	self.where(id: role_ids).pluck(:name)
  end

  def self.findRRMEmail(request)
  	request = request.request_activities.find_by(request_id: request.id,request_status: 'approved',user_type: ['RRM','HO'])
  	if request != nil then request.user.email else DEFAULT_EMAILS end
  end

  def self.findRRMName(request)
    request = request.request_activities.find_by(request_id: request.id,request_status: 'approved',user_type: ['RRM','HO'])
    if request != nil then request.user.name else 'No Record' end
  end

  def self.isRRM?(current_user)
    current_user.roles.pluck(:name).include?('rrm')
  end

  def self.isCMO?(current_user)
    current_user.roles.pluck(:name).include?('cmo')
  end

end