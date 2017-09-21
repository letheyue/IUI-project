require 'yelp_client.rb'

class StaticPagesController < ApplicationController
  def home
    food_result_for_college_station = YelpClient.search({})
    render json:food_result_for_college_station
  end

  def help
  end

  def contact
  end
end
