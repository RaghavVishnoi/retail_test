class CMO < ActiveRecord::Base
  has_many :requests
  belongs_to :user, :foreign_key => :email

  validates :name,:location,:designation,:email,:phone, :presence => true
 
  
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