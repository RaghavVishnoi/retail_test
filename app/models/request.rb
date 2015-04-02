class Request < ActiveRecord::Base
  include Fields

  has_many :images, :as => :imageable, :dependent => :destroy
  belongs_to :declined_by_user, :class_name => 'User'
  belongs_to :approved_by_user, :class_name => 'User'

  state_machine :status, :initial => :pending do
    event :approve do
      transition :pending => :approved
    end
    event :decline do
      transition :pending => :declined
    end
  end

  def self.with_query(q)
    q = {} if !q.present? 
    requests = self
    if q[:status].present?
      requests = requests.where(:status => q[:status])
    end
    requests
  end
end