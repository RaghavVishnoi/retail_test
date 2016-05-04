class CMO < ActiveRecord::Base
  has_many :requests
  belongs_to :rrm
  belongs_to :user, :foreign_key => :email

  validates :name,:location,:designation,:phone, :presence => true
  validates :email, :presence => true, :uniqueness => {:message => "email already exist"}
  
  def self.search(id)
	 @cmo = CMO.where("name like ?", "%#{id}%") 
  end
 

  def self.display_names
    all.map { |c| 
      if c.display_name != nil
        [c.display_name, c.id] 
      end

    }
  end

  def display_name
  	if status == 'Active'
     "#{designation} #{location} - #{name}"
    end
  end

   
end