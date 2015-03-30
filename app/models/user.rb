class User < ActiveRecord::Base
  attr_accessor :skip_password_validation, :password_required
  attr_writer :shift_start_time, :shift_end_time

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

  validates_confirmation_of :password, :if => ->{ password.present? }
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :reset_password_token, :uniqueness => true, :allow_nil => true
  validates :password, :presence => true, :unless => :password_not_required?

  before_validation :set_shift_time_in_seconds
  before_save :ensure_auth_token
  before_create :set_reset_password_token
  after_create :send_invite_mail

  scope :with_password, -> { where('password_digest is not null') }
  scope :with_email, ->(email) { where(:email => email) }

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
end