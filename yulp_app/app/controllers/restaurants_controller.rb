class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.all

  end

  def index
    @restaurant = Restaurant.all

  end




end