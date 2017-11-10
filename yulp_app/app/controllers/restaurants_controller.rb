class RestaurantsController < ApplicationController


  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).all
  end



end