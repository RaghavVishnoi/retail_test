class CMO < ActiveRecord::Base
  has_many :requests
  
  def self.display_names
    all.map { |c| [c.display_name, c.id] }
  end

  def display_name
    "#{designation} #{location} - #{name}"
  end
end