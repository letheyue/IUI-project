class UsersController < ApplicationController

  before_action :valid_user_id, except: [:new]


  def new
    @user = User.new
  end

  def show
    # @user = current_user
    @reviews = current_user.reviews
    # only 10 most recent records
    @histories = current_user.search_histories.order(updated_at: :desc).take(10)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Yulp App!"
      log_in @user
      redirect_to @user
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

  def valid_user_id
    # byebug
    unless current_user && params[:id].present? && current_user.id.to_s == params[:id]
      flash[:danger] = 'You are not authorized to access this page. Redirecting you to home/profile page'
      redirect_to login_path
    end
  end


end
