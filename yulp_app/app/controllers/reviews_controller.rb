class ReviewsController < ApplicationController
  include SessionsHelper
  before_action :validate_login
  layout 'review', only: [:new_reviews]

  def new
    @review = Review.new
  end

  def create
      @review = Review.new(review_params)
      @review.user_id = current_user.id
      @review.user_name = current_user.name
      @review.restaurant_id = params[:restaurant_id].to_i
      if params["rating-input-1"] == "on"
        @review.rating = 1
      elsif params["rating-input-2"] == "on"
        @review.rating = 2
      elsif params["rating-input-3"] == "on"
        @review.rating = 3
      elsif params["rating-input-4"] == "on"
        @review.rating = 4
      elsif params["rating-input-5"] == "on"
        @review.rating = 5
      end

      if @review.save(validate: false)
        flash[:success] = 'Review created successfully.'
      else
        flash[:danger] = 'Failed.'
        redirect_to restaurants_path()
      end
      redirect_to restaurants_path()

  end

  private


  def validate_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to login_path
    end
  end

  def review_params

    params.require(:review).permit(:user_id, :rating, :user_image_url, :user_name, :text, :time_created,
                                       :restaurant_id)
  end


end