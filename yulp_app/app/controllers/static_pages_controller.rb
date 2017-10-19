require 'yelp_client.rb'
require 'google_client.rb'


class StaticPagesController < ApplicationController
  def home

    # food_result_for_college_station = YelpClient.search({})
    # render json:food_result_for_college_station
    # byebug

  end

  def help
    # Used to test the crawler function for fetching popular times

    places = Hash.new
    # places["Gary Danko"] ="800 N Point St"
    # places["buffalo wild wings"] ="903 University Dr E"
    # places["red lobster"] = "1200 University Dr E"
    places["Centro American Restaurant Pupuseria & Pupuseria"] = "317 Dominik Dr"
    @result_hash = Hash.new

    GoogleClient.get_all_popular_times(places).each do |name, result|
      one_place_result = Hash.new
      result.each do |day, times|
        hash_times = Hash.new
        times.each_with_index do |times, index|
          hash_times[(index+7).modulo(24)] = times
        end
        one_place_result[day] = hash_times
      end
      @result_hash[name] = one_place_result
    end


    # result = GoogleClient.get_popular_times("Gary Danko","800 N Point St")
    # result = GoogleClient.get_popular_times("buffalo wild wings","903 University Dr E")
    # result = GoogleClient.get_popular_times("red lobster","1200 University Dr E")
    # result.each do |day, times|
    #   hash_times = Hash.new
    #   times.each_with_index do |times, index|
    #     hash_times[index+7] = times
    #   end
    #   @result_hash[day] = hash_times
    # end

  end

  def contact

    # Used to test creation of restaurants
    # Restaurant.setup_table
    SetupDbJob.perform_later

  end
end