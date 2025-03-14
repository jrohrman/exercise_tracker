class User < ApplicationRecord
  has_secure_password
  
  before_save :generate_token
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64
  end
end