class Customer < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  validates :state, :inclusion => { :in => ADDRESS_STATES }

  def as_json
    super(except: [:avatar]).merge(:avatar_url => avatar_url)
  end
end