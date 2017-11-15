class RestaurantsController < ApplicationController


  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).all
  end

  def search
    @restaurant = Restaurant.all.order("name ASC").page params[:page]

    if params[:search]
      @restaurant = Restaurant.search(params[:search]).order("name ASC").page params[:page]
    else
      @restaurant = Restaurant.all.order("name ASC").page params[:page]
    end
  end


end