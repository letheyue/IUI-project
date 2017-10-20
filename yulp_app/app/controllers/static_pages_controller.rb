require 'yelp_client.rb'
require 'crawler_client.rb'


class StaticPagesController < ApplicationController
  def home
    # food_result_for_college_station = YelpClient.search({})
    # render json:food_result_for_college_station

    # Used to test db setup
    SetupDbJob.perform_later
  end

  def help
    # Used to test the crawler function for fetching popular times

    places = Hash.new
    # places["Gary Danko"] ="800 N Point St"
    # places["buffalo wild wings"] ="903 University Dr E"
    # places["red lobster"] = "1200 University Dr E"
    places["Centro American Restaurant Pupuseria & Pupuseria"] = "317 Dominik Dr"
    @result_hash = Hash.new

    CrawlerClient.get_all_popular_times(places).each do |name, result|
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

  end

  def contact

  end
end