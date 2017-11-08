class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.all

  end

<<<<<<< HEAD
<<<<<<< HEAD
  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).order(id: :asc).all

  end
=======

>>>>>>> Aggregated Commit for Rest View
=======
  def index
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => 5).order(id: :asc).all

  end
>>>>>>> Fix Layout




end