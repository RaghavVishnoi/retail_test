class User < ActiveRecord::Base
  enum role: ['manager', 'rep']
  has_secure_password
  validates :email, :presence => true
  # validates :password, :length => { :minimum => 6 }
  before_save :ensure_auth_token

  def personalized_message
    "Hi #{name}"
  end

  private

    def ensure_auth_token
      if auth_token.blank?
        self.auth_token = generate_token
      end
    end

    def generate_token
      loop do
        token = SecureRandom.hex(16)
        break token unless User.where(:auth_token => token).first
      end
    end
end