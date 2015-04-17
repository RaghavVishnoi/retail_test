class Request < ActiveRecord::Base
  include Fields

  enum request_type: ["gsb", "sis", "in_shop"]

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

  validates :request_type, :presence => true, :if => :is_rsp?
  validates :cmo_name, :retailer_code, :rsp_name, :rsp_mobile_number, :state, :city, :shop_name, :shop_address, :shop_owner_name, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :presence => true, :if => :is_rsp?
  validates :is_sis_installed, :inclusion => { :in => [true, false] }, :if => "is_rsp? && (gsb? || in_shop?)"
  validates :is_main_signage, :inclusion => { :in => [true, false] }, :if => [:is_rsp?, :gsb?]
  validates :width, :height, :presence => true, :if => [:is_rsp?, :gsb?]
  validates :is_gionee_gsb_present, :inclusion => { :in => [true, false] }, :if => [:is_rsp?, :in_shop?]
  validate :validate_shop_requirements, :if => [:is_rsp?, :in_shop?]

  def self.with_query(q)
    q = {} if !q.present? 
    requests = self
    if q[:status].present?
      requests = requests.where(:status => q[:status])
    end
    requests
  end

  def self.with_retailer_code(q)
    if q.present?
      where("retailer_code like ?", "%#{q}%")
    else
      self
    end
  end

  def shop_requirements
    properties.select { |property| property[:field][:configuration][:name] == "shop_requirements" }.first
  end

  def branding_details
    properties.select { |property| property[:field][:configuration][:type] == "branding_details" }
  end

  def image_ids_string=(str)
    self.image_ids = str.split(',')
  end

  private

  def validate_shop_requirements
    if !(shop_requirements && shop_requirements[:values].present?)
      errors[:shop_requirements] << "can't be blank"
    end
  end
end