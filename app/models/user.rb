class User < ApplicationRecord
  after_create :assign_authentication_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, length: { minimum: 8 }, allow_blank: true

  def assign_authentication_token
    auth_token = User.new_token
    self.update_attributes(authentication_token: auth_token, authentication_token_digest: User.digest(auth_token), authentication_token_expiry_date: Date.today + 1.year)
  end
  
end
