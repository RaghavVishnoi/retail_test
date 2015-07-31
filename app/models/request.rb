class Request < ActiveRecord::Base
  include Fields

  enum request_type: ["gsb", "sis", "in_shop", "maintenance", "visitor"]
  TYPE_OF_ISSUE = ['SIS', ' GSB', 'Clipon', 'Countertop', 'Standee', 'Other']
  TYPE_OF_PROBLEM = ['Damage to material', 'Electrical – lights etc not working', 'Security System related', 'Wrong Placement – Need to shift location', 'Wrong Shop – Need to remove from shop', 'Quality / finish issue', 'Visual / artwork to be changed', 'other']
  

  has_many :images, :as => :imageable, :dependent => :destroy
  belongs_to :declined_by_user, :class_name => 'User'
  belongs_to :approved_by_user, :class_name => 'User'
  belongs_to :cmo, :class_name => 'CMO'
  belongs_to :retailer,:class_name => 'RetailerState'
   
  state_machine :status, :initial => :cmo_pending do
    event :cmo_approve do
       transition :cmo_pending => :pending
    end
    event :cmo_decline do
       transition :cmo_pending => :cmo_declined
    end
    event :approve do
       transition :pending => :approved
    end
    event :decline do
       transition :pending => :declined
    end


    after_transition any => [:approved, :declined], :do => :notify_cmo
    
  end

  validate :appprover_approve_date,:cmo_approve_date, :if => [:sis?,:in_shop?,:gsb?,:maintenance?]
  validates :is_rsp, :inclusion => { :in => [true, false] },:if => [:sis?,:in_shop?,:gsb?,:visitor?]
  validates :rsp_not_present_reason, :presence => true, :unless => :is_rsp?,:if => [:sis?,:in_shop?,:gsb?]
  validates :rsp_name, :rsp_mobile_number, :presence => true, :if => :is_rsp?,:if => [:sis?,:in_shop?,:gsb?]
  validates :request_type, :presence => true,:if => [:sis?,:in_shop?,:gsb?]
  validates :cmo, :state, :city, :shop_name, :shop_address, :shop_owner_name, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :retailer_code, :presence => true,:if => [:sis?,:in_shop?,:gsb?]
  validates :is_sis_installed, :inclusion => {:in => [true, false] }, :if => "(gsb? || in_shop? )"
  validates :is_main_signage, :inclusion => { :in => [true, false] }, :if => :gsb?
  validates :width, :height, :type_of_gsb_requested, :presence => true, :if => :gsb?
  validates :is_gsb_installed_outside?, :inclusion => { :in => [true, false] }, :if => :in_shop?
  validates :type_of_sis_required, :presence => true, :if => :sis?
  validates :is_gionee_gsb_present, :inclusion => { :in => [true, false] }, :if => [:sis?]
  validates :space_available, :presence => true, :if => [:sis?, :in_shop?]
  validate :validate_shop_requirements, :if => :in_shop?
  validate :maintenance_requestor,:maintenance_requestor_mobile_number,:type_of_issue,:type_of_problem, :if => :maintenance?
  validate :shop_visit_date,:shop_visit_done_by,:is_standee_present,:visitor_contact_number,:store_selling_gionee,:is_clipon_present,:is_countertop_present,:is_leaflets_available,:no_of_peace_in_stock,:is_wall_poster_in_shop,:is_dangler_in_shop,:rsp_assigned_in_store,:rsp_present_in_shop,:rsp_in_gionee_tshirt,:rsp_well_groomed,:rsp_selling_skills,:gsb_type_installed,:location_of_gsb,:gsb_cleanliness,:installation_quality,:is_gsb_light_woring,:is_gsb_light_throw_is_good,:gsb_structured_damage,:gsb_other_problem,:gsb_retailer_feedback,:is_sis_present,:is_sis_placed_properly,:is_sis_condition_good,:is_sis_cleaned_daily,:is_sis_damaged,:sis_structured_flaws,:sis_security_alarm_working,:sis_security_device_charging,:sis_demo_phones_installed,:spec_card_demo_phone_match,:backwall_light_working_properly,:is_counter_lights_working,:is_clip_on_lights,:dealer_switch_on_sis_lights,:updated_gionee_creative,:sis_any_problem,:sis_retailer_feedback,:is_good_visibility_in_store,:lit_in_store,:has_a_relevant_visual,:overall_rating,:is_clipon_not_working_properly,:overall_comments, :if => :visitor?


 def self.with_query(q)
    q = {} if !q.present? 
    requests = self

    if q[:status].present? && q[:request_type].present?
      requests = requests.where(:status => q[:status],:request_type => q[:request_type])
    end
    requests
  end

  def self.with_cmo_query(q,id)
    q = {} if !q.present? 
    requests = self
    user = User.find_by(:id => id)
    email = user.email
    cmo = CMO.where(:email => email)
    if q[:status].present? && q[:request_type].present?
      requests = requests.where(:status => q[:status],:request_type => q[:request_type],:cmo_id => cmo)
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

def self.cmo_id(id)
    
    user = User.find_by(:id => id)
    email = user.email
    cmo = CMO.find_by(:email => email)
    cmo_id = cmo.id

end

def self.user_role(id)
  user = User.find_by(:id => id)
  associated_roles = AssociatedRole.find_by(:object_id => id)
  role = associated_roles.role
  
end


  def notify_cmo
    RequestMailer.delay.status_mail(id)
  end
end