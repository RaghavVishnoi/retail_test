class RRM < ActiveRecord::Base
  has_many :cmos

  validates :name,:location,:designation,:phone, :presence => true
  validates :email, :presence => true, :uniqueness => {:message => "email already exist"}
   

  def self.search(id)
	@rrm = RRM.where("name like ?", "%#{id}%") 
  end
 
end
