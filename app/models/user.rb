class User < ApplicationRecord
  attr_accessor :authentication_token
  after_create :assign_authentication_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, length: { minimum: 8 }, allow_blank: true

  def assign_authentication_token
    auth_token = User.new_token
    self.update_attributes(authentication_token: auth_token, authentication_token_digest: User.digest(auth_token), authentication_token_expiry_date: Date.today + 1.year)
  end

  def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

  class << self
    #returns the hash digest of the given string
  	def digest(string)
  		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
  													  BCrypt::Engine.cost
  		BCrypt::Password.create(string, cost: cost)
  	end

  	#returns a rendom token
  	def new_token
  		SecureRandom.urlsafe_base64
  	end
  end


end
