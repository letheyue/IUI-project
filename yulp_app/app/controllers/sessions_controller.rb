class SessionsController < ApplicationController
  def new
    # byebug
    if logged_in?
      redirect_to user_path(current_user)
    end
  end

  def create
    # first check for FB & Google login
    if params[:session].nil?||params[:session][:email].nil?
      user = User.from_omniauth(env["omniauth.auth"])
      if user
        session[:user_id] = user.id
        redirect_to user
        return
      end
    end

    # then perform normal searching
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
