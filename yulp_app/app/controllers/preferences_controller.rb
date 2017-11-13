class PreferencesController < ApplicationController
  before_action :set_preference, only: [:index, :edit]
  def new
    @preference = Preference.new
  end

  def index
  end

  def create
    #@preference = current_user.create_preference(preference_params)
    @preference = Preference.new(preference_params)
    @preference.user_id= current_user.id
    if @preference.save(validate: false)
      flash[:notice] = "Preference created successfully."
      render('edit')
    else
      flash[:notice] = "Failed."
      render('edit')
    end
  end

  def edit

  end

  def update
      if current_user.preference.update(preference_params)
        render('edit')
      else
        render('edit')
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end

  end


  private

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