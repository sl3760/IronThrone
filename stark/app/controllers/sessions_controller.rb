class SessionsController < ApplicationController
  def new
  end

  def create
    session_params = params[:session];
    puts session_params
    email = nil
    password = nil
    if session_params.instance_of?(String)
      args_array = session_params.split("\'");
      password = args_array[3]
      email = args_array[7]
      puts password
      puts email
    else
      email = session_params[:email]
      password = session_params[:password]
    end
    user = User.find_by_email(email.downcase)
    if user && user.authenticate(password)
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def facebook_create
    user = FacebookUser.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    facebook_sign_in user
    redirect_to root_url
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end