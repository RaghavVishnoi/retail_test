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
  has_many :vendor_requests
  has_many :retailers
  belongs_to :user
  has_many :request_activities
  has_many :shop_assignments
  has_one :request_assignment

  has_one :shop_audit,dependent: :destroy
  accepts_nested_attributes_for :shop_audit, :allow_destroy => true, reject_if: :all_blank
   
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
  after_transition any => [:approved], :do => :notify_for_vendor  
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
  validate :shop_visit_date,:shop_visit_done_by,:is_standee_present,:visitor_contact_number,:store_selling_gionee,:is_clipon_present,:is_countertop_present,:is_leaflets_available,:no_of_peace_in_stock,:is_wall_poster_in_shop,:is_dangler_in_shop,:rsp_assigned_in_store,:rsp_present_in_shop,:rsp_in_gionee_tshirt,:rsp_well_groomed,:rsp_selling_skills,:gsb_type_installed,:location_of_gsb,:gsb_cleanliness,:installation_quality,:is_gsb_light_woring,:is_gsb_light_throw_is_good,:gsb_structured_damage,:gsb_other_problem,:gsb_retailer_feedback,:is_sis_present,:is_sis_placed_properly,:is_sis_condition_good,:is_sis_cleaned_daily,:is_sis_damaged,:sis_structured_flaws,:sis_security_alarm_working,:sis_security_device_charging,:sis_demo_phones_installed,:spec_card_demo_phone_match,:backwall_light_working_properly,:is_counter_lights_working,:is_clip_on_lights,:dealer_switch_on_sis_lights,:updated_gionee_creative,:sis_any_problem,:sis_retailer_feedback,:is_good_visibility_in_store,:lit_in_store,:has_a_relevant_visual,:overall_rating,:is_clipon_not_working_properly,:overall_comments,:is_audit_done,:store_open,:store_renovation,:store_shifted,:not_allowed_in_store, :if => :visitor?
  validate :other_name,:other_phone,:other_address,:lfr_name,:lfr_phone,:lfr_app_user_id
  validate :state_id
  after_create :notify_cmo

   

  def self.search(param,type)
    if type == 'Request Id'
      @request = Request.find_by(id: param)
    else
      @request = Request.where(:retailer_code => param)
    end
    
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

def self.get_cmo_id(id)  
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

def self.retailer_requests(retailer_code)
  Request.where(:retailer_code => retailer_code)
end

def self.change_status(status,request_id)
  Request.where(:id => request_id).update_all(status: status)
end

 def notify_cmo
    #RequestMailer.delay.status_mail(id)
 end

 def notify_for_vendor
    VendorMailer.delay.requestApproved(self)
 end



def self.date(request)
  case request.status
    when 'cmo_pending'
      ''
    when 'cmo_declined'
      date = request.cmo_approve_date
    when  'pending'
      date = request.cmo_approve_date
    when  'pending'  
      date = ''
    when 'declined'
      date = request.cmo_approve_date
    when 'approved'
      date = request.cmo_approve_date
    end
  end
  
  def self.request_count_by_state(state,status,request_type,from,to)
    start_date = if from != '' && from != nil then from else (Time.now - 1.month).to_date end
    end_date = if to != '' && to != nil then (Time.parse(to) + 1.day) else Time.now.to_date + 1 end
    Request.where(state_id: State.find_by(name: state).id,status: status,request_type: request_type,created_at: start_date..end_date).count
  end

  def self.find_requests(current_user,params)
    requests = user_state(current_user,params)
     if params[:retailer] != '' && params[:retailer] != nil 
      @requests = requests.where(retailer_code: params[:retailer])
     else
      @requests = requests
    end
    @requests  
  end

  def self.request_approver(id,role)
        request_activity = RequestActivity.where('request_id = ? AND user_type = ? AND user_id != 0',id,role).last
        User.find(request_activity.user_id) if request_activity != nil
  end

  def self.user_state(current_user,params)
      user_states = current_user.user_states.pluck(:state_id) 
      start_date = if params[:from] != '' && params[:from] != nil then params[:from] else (Time.now - 1.month).to_date end
      end_date = if params[:to] != '' && params[:to] != nil then params[:to] else Time.now.to_date end      
      state = if params[:state] == 'All' then State.states(current_user) else State.where(name: params[:state].split(',')).pluck(:id) end
      case user_role(current_user.id).name
      when 'approver','superadmin'
        if params[:q][:uid] != nil
          cmo_request(params[:q][:uid],start_date,end_date,params,state)
        else
          if params[:q][:request_type] != '4'   
            Request.where(:request_type => params[:q][:request_type],:status => params[:q][:status].split(','),:created_at => start_date..Time.parse(end_date.to_s) + 1.day,state_id: state)      
          else
            if params[:audit] != nil
               Request.where(:request_type => params[:q][:request_type],:status => params[:q][:status].split(','),:created_at => start_date..Time.parse(end_date.to_s) + 1.day,state_id: state,is_audit_done: params[:audit])      
            else
              Request.where(:request_type => params[:q][:request_type],:status => params[:q][:status].split(','),:created_at => start_date..Time.parse(end_date.to_s) + 1.day,state_id: state)      
            end
          end
        end
      else 
        if params[:q][:uid] != nil
           cmo_request(params[:q][:uid],start_date,end_date,params,state)
        else 
          if params[:q][:request_type] != '4'    
            cmo_request(current_user.auth_token,start_date,end_date,params,state)
          else
            if params[:audit] != nil
               Request.where(:request_type => params[:q][:request_type],:status => params[:q][:status].split(','),:created_at => start_date..Time.parse(end_date.to_s) + 1.day,state_id: state,is_audit_done: params[:audit])      
            else
              Request.where(:request_type => params[:q][:request_type],:status => params[:q][:status].split(','),:created_at => start_date..Time.parse(end_date.to_s) + 1.day,state_id: state)      
            end
          end
        end
      end
      
  end

  def self.cmo_request(uid,start_date,end_date,params,state)
    user = User.find_by(auth_token: uid)
    end_date = Time.parse(end_date.to_s) + 1.day
    pending = Request.where(request_type: params[:q][:request_type].split(','),created_at: start_date..end_date,state_id: state,status: 'cmo_pending')
    request = Request.where(request_type: params[:q][:request_type].split(','),created_at: start_date..end_date,state_id: state,status: params[:q][:status].split(','))
     if params[:q][:status].split(',').include?("cmo_pending")
       req = pending.merge!(request)
       req 
     else
      request
    end
   end

  def self.store_monthly_sale(amount)
    case amount.to_i
    when 0
      "0-10 Lac"
    when 1000000
      "10-20 Lac"
    when 2000000
      "20-50 Lac"
    when 5000000
      "50 Lac-1 Cr"
    when 10000000
      "1 Cr to 3 Cr"
    when 30000000
      "3 Cr and above"
    end  

  end

  def self.gionee_monthly_sale(amount)
    case amount.to_i
    when 0
      "0-50 Thousand"
    when 50000
      "50 Thousand - 1 Lac"
    when 100000
      "1 Lac - 2 Lac"
    when 200000
      "2 Lac - 4 Lac"
    when 400000
      "4 Lac - 7 Lac"
    when 700000
      "7 Lac - 15 Lac"
    when 1500000
      "15 Lac - 30 Lac"
    when 3000000
      "30 Lac and above"
    end  
  end

  def self.audit_count_by_state(state,status,from,to)
    start_date = if from != '' && from != nil then from else (Time.now - 1.month).to_date end
    end_date = if to != '' && to != nil then (Time.parse(to) + 1.day) else Time.now.to_date + 1 end
    case status
    when 0
      Request.where(request_type: 4,created_at: start_date..end_date,state_id: State.find_by(name: state).id,is_audit_done: false).count
    else
      Request.where(request_type: 4,created_at: start_date..end_date,state_id: State.find_by(name: state).id,is_audit_done: true).count
    end
  end

  def self.is_audit(retailer_code)
      audit = {}
      request = Request.where(request_type: 4,retailer_code: retailer_code)
      if request.length != 0 && request != nil
        audit[:result] = 'Yes'
        lattest_audit = request.last
        audit[:audit_date] = lattest_audit.created_at.strftime("%d %b,%Y")
        audit[:audit_by] = lattest_audit.shop_visit_done_by
        audit[:is_audit_done] = lattest_audit.is_audit_done
        audit[:total_audit] = request.count
        audit
      else
        audit[:result] = 'No'
        audit
      end
      
  end

  


  


end



