class PreferencesController < ApplicationController
  include SessionsHelper
  before_action :validate_login
  before_action :set_preference, only: [:edit]

  def new
    @preference = Preference.new
  end

  def index
    @preference = current_user.preference
  end

  def show
    @preference = current_user.preference
  end

  def create
    if current_user.preference.nil?
      @preference = Preference.new(preference_params)
      @preference.user_id= current_user.id
      if @preference.save(validate: false)
        flash[:success] = 'Preference created successfully.'
      else
        flash[:danger] = 'Failed.'
        redirect_to user_preference_path(current_user.id)
      end
    else
      @preference = current_user.preference
      flash[:warning] = 'Already have a Preference for you in our database.'
    end
    redirect_to user_preference_path(current_user.id, @preference.id)

  end

  def edit

  end

  def update
    byebug
    if current_user.preference.update(preference_params)
        render('edit')
      else
        render('edit')
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end

  end







  private

  def validate_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to login_path
    end
  end

  def set_preference
    #@preference = Preference.where(user_id: current_user.id)
    @preference = Preference.find(current_user.id)
  end

  def preference_params
    params.require(:preference).permit(:user_id, :price, :discount, :popularity, :rating, :crowded,
                                       :show_rating, :show_reviews, :show_discount, :show_popular_time,
                                       :restaurants_per_page)
  end


end