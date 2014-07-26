class FacebookUser < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.new_remember_token
      SecureRandom.urlsafe_base64
  end

  def self.digest(token)
      Digest::SHA1.hexdigest(token.to_s)
  end
end
