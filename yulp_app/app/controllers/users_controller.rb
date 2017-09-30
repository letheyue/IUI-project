class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    # byebug
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Yulp App!"
      redirect_to @user
      log_in @user
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :provider, :uid, :oauth_token, :oauth_expires_at)
  end

end
