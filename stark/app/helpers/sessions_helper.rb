module SessionsHelper#Session Helpers
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  def facebook_sign_in(user)
    remember_token = user.oauth_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:oauth_token, FacebookUser.digest(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def facebook_signed_in?
    !facebook_current_user.nil?
  end
  
  def current_user= (user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    return @current_user
  end

  def facebook_current_user
    remember_token = FacebookUser.digest(cookies[:remember_token])
    @current_user ||= FacebookUser.find_by(oauth_token: remember_token)
    return @current_user
  end

  def sign_out
    a = self.current_user
    b = self.facebook_current_user
    if a != nil
      a.update_attribute(:remember_token, User.digest(User.new_remember_token))
    else
      b.update_attribute(:oauth_token, User.digest(User.new_remember_token))
    end
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end