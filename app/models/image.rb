class Image < ActiveRecord::Base
  attr_accessor :skip_reverse_geocode
  mount_uploader :image, ImageUploader
  
  belongs_to :imageable, :polymorphic => true

  validates :image, :presence => true

  after_save :reverse_geocode, :unless => :skip_reverse_geocode

  private
    def reverse_geocode
      begin
        if lat? && long?
          geocode = Geocoder.search([lat, long]).first
          self.skip_reverse_geocode = true
          self.update_attribute(:address, geocode.address) if geocode
        end
      rescue
        nil
      end
    end

    handle_asynchronously :reverse_geocode
end