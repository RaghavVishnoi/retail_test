class User < ActiveRecord::Base
  attr_accessor :skip_password_validation
  include RoleModel
  roles :superadmin, :admin, :manager, :user
  has_secure_password :validations => false

  has_and_belongs_to_many :departments
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :business_units
  has_and_belongs_to_many :job_titles

  validates_confirmation_of :password, :if => ->{ password.present? }
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :reset_password_token, :uniqueness => true, :allow_nil => true
  validates :password, :presence => true, :unless => :password_not_required?

  before_save :ensure_auth_token
  before_create :set_reset_password_token
  after_create :send_invite_mail

  scope :with_password, -> { where('password_digest is not null') }
  scope :with_email, ->(email) { where(:email => email) }

  def personalized_message
    "Hi #{name}"
  end

  private
    
    def password_not_required?
      skip_password_validation || password_digest?
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

    def set_reset_password_token
      self.reset_password_sent_at = Time.current
      self.reset_password_token = generate_token(:reset_password_token)
    end

    def send_invite_mail
      UserMailer.delay.invite_mail(email, reset_password_token)
    end
end