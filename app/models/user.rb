class User < ActiveRecord::Base
  include RoleModel
  roles :superadmin, :admin, :manager, :user
  has_secure_password :validations => false
  validates_confirmation_of :password, :if => ->{ password.present? }
  validates :email, :presence => true, :uniqueness => true
  validates :reset_password_token, :uniqueness => true, :allow_nil => true
  # validates :password, :length => { :minimum => 6 }
  before_save :ensure_auth_token
  before_create :set_reset_password_token
  after_create :send_invite_mail

  def personalized_message
    "Hi #{name}"
  end

  private

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