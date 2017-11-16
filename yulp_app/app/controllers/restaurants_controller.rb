class RestaurantsController < ApplicationController


  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).all.order("name ASC")
  end

  def search
    # @restaurant = Restaurant.all.order("name ASC").page params[:page]
    if params[:search]
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).search(params[:search])
    else
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).all.order("name ASC")
    end
  end


end