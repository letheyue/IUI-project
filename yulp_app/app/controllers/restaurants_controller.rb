class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.all

  end

  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).order(id: :asc).all

  end




end