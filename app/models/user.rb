class User < ActiveRecord::Base
  attr_accessor :skip_password_validation, :password_required
  attr_writer :shift_start_time, :shift_end_time

  USER_TYPE = ['All','CMO','APPROVER','REQUESTER']

  has_secure_password :validations => false

  has_many :associated_roles, :as => :object, :dependent => :destroy
  has_many :roles, :through => :associated_roles
  has_many :permissions, :through => :roles
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :business_units
  has_and_belongs_to_many :job_titles
  has_and_belongs_to_many :weekly_offs
  has_many :data_files_users
  has_many :data_files, :through => :data_files_users
  has_many :owned_files, :class_name => "DataFile", :foreign_key => :user_id
  has_many :attendances, :dependent => :destroy
  has_many :users_reportings, :foreign_key => :report_to_user_id, :dependent => :destroy
  has_many :users_to_report, :foreign_key => :reporting_user_id, :class_name => "UsersReporting", :dependent => :destroy
  has_many :reporting_users, :through => :users_reportings
  has_many :report_to_users, :through => :users_to_report
  has_many :reporting_users_attendances, :through => :users_reportings, :source => :attendances
  has_many :customers_users, :dependent => :destroy
  has_many :customers, :through => :customers_users
  has_many :cmos
  has_many :users

  validates_confirmation_of :password, :if => ->{ password.present? }
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :state, :presence => true
  validates :reset_password_token, :uniqueness => true, :allow_nil => true
  validates :password, :presence => true, :unless => :password_not_required?

  before_validation :set_shift_time_in_seconds
  before_save :ensure_auth_token
  before_create :set_reset_password_token
  after_create :send_invite_mail

  scope :with_password, -> { where('password_digest is not null') }
  scope :with_email, ->(email) { where(:email => email,:status => 'Active') }

  def self.with_name(name)
    if name.present?
      where("name like ?", "%#{name}%")
    else
      []
    end
  end

  def personalized_message
    "Hi #{name}"
  end

  def set_reset_password_token
    self.reset_password_sent_at = Time.current
    self.reset_password_token = generate_token(:reset_password_token)
  end

  def attendance
    attendances.between_time(Time.current.beginning_of_day, Time.current.end_of_day).first || attendances.new
  end

  def shift_start_time
    TimeHandler.day_time(timezone, shift_start_time_in_seconds)
  end

  def shift_end_time
    TimeHandler.day_time(timezone, shift_end_time_in_seconds)
  end

  private
    
    def password_not_required?
      !password_required && (skip_password_validation || password_digest?)
    end

    def ensure_auth_token
      if auth_token.blank?
        self.auth_token = generate_token(:auth_token)
      end
    end

    def generate_token(col)
      loop do
        token = SecureRandom.hex(16)
        break token unless User.where(col => token).first
      end
    end

    def self.get_role(id)
      @user = User.find_by(:id => id)
      @associated_roles = AssociatedRole.find_by(:object_id => id)
      @role = @associated_roles.role.name 
    end

    def self.approver_users(role)
      @role = Role.where(:name => ['vendor','cmo','requester'])
      @associated_roles = AssociatedRole.where(:role_id => @role)
      @object_id = []
      @associated_roles.each do |associated_roles|
        @object_id = @object_id.push(associated_roles.object_id)
      end
      @users = User.where(:id => @object_id)
   end

   def self.find_users(role)
      @role = Role.where(:name => role)
      @associated_roles = AssociatedRole.where(:role_id => @role)
      @object_id = []
      @associated_roles.each do |associated_roles|
        @object_id = @object_id.push(associated_roles.object_id)
      end
      @users = User.where(:id => @object_id)
   end

    def self.search(id,roles)
      if roles.name == 'superadmin'
        @users = User.where(:email => id)
      else
        users = User.where(:email => id)
      end
        associated_roles = AssociatedRole.find_by(:object_id => users)
        if associated_roles != nil && associated_roles != ''
        role = associated_roles.role
          if role.name == 'cmo' || role.name == 'vendor' || role.name == 'requester'
            user = User.where(:email => id)
          else
            user = ''
          end
        end
      user
    end

    def send_invite_mail
       UserMailer.delay.invite_mail(email, reset_password_token)
    end

    def set_shift_time_in_seconds
      if @shift_start_time
        self.shift_start_time_in_seconds = TimeHandler.seconds(timezone, @shift_start_time)
      end
      if @shift_end_time
        self.shift_end_time_in_seconds = TimeHandler.seconds(timezone, @shift_end_time)
      end
    end

    def self.user_roles(id)
      user = User.find_by(:id => id)
      associated_roles = AssociatedRole.where(:object_id => id) 
      role = []
        associated_roles.each do |associated_role|
          role.push(associated_role.role.name)   
        end
        role
    end

    def self.user_role(id)
      user = User.find_by(:id => id)
      associated_roles = AssociatedRole.find_by(:object_id => id)
      role = associated_roles.role
    end
end