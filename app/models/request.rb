class Request < ActiveRecord::Base
  include Fields

  enum request_type: ["gsb", "sis", "in_shop"]

  has_many :images, :as => :imageable, :dependent => :destroy
  belongs_to :declined_by_user, :class_name => 'User'
  belongs_to :approved_by_user, :class_name => 'User'
  belongs_to :cmo, :class_name => 'CMO'
  belongs_to :retailer,:class_name => 'RetailerState'


  state_machine :status, :initial => :pending do
    event :approve do
      transition :pending => :approved
    end
    event :decline do
      transition :pending => :declined
    end

    after_transition any => [:approved, :declined], :do => :notify_cmo
  end

  validates :is_rsp, :inclusion => { :in => [true, false] }
  validates :rsp_not_present_reason, :presence => true, :unless => :is_rsp?
  validates :rsp_name, :rsp_mobile_number, :presence => true, :if => :is_rsp?
  validates :request_type, :presence => true
  validates :cmo, :state, :city, :shop_name, :shop_address, :shop_owner_name, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :retailer_code, :presence => true
  validates :is_sis_installed, :inclusion => { :in => [true, false] }, :if => "(gsb? || in_shop?)"
  validates :is_main_signage, :inclusion => { :in => [true, false] }, :if => :gsb?
  validates :width, :height, :type_of_gsb_requested, :presence => true, :if => :gsb?
  validates :is_gsb_installed_outside?, :inclusion => { :in => [true, false] }, :if => :in_shop?
  validates :type_of_sis_required, :presence => true, :if => :sis?
  validates :is_gionee_gsb_present, :inclusion => { :in => [true, false] }, :if => [:sis?]
  validates :space_available, :presence => true, :if => [:sis?, :in_shop?]
  validate :validate_shop_requirements, :if => :in_shop?

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

  def self.between_time(start_time, end_time)
    where("created_at between ? and ?", start_time, end_time)
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

  def notify_cmo
    RequestMailer.delay.status_mail(id)
  end
end