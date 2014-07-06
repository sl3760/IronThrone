class User < ActiveRecord::Base
	has_secure_password

	before_save { |user| user.email = email.downcase }
	before_create :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true,
						length: {maximum: 50}
	validates :email, presence: true,
						format: {with: VALID_EMAIL_REGEX},
						uniqueness: {case_sensitive: false}

	validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.hash(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			self.remember_token = User.hash(User.new_remember_token)
		end
end
