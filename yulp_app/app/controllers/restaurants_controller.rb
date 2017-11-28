require 'nokogiri'

class RestaurantsController < ApplicationController
  include SessionsHelper
  before_action :validate_login
  # before_action :valid_user_id

  def index
    @preference = get_preference
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).all.order("name ASC")
    # Use of Review.all will have performance issues, which is not preferred
    # For now, apply cache mechanism
    @reviews = Review.get_all_reviews.reverse_order
  end

  def search
    @preference = get_preference
    raw_results = Restaurant.custom_search(params[:search], @preference)

    # byebug
    if params[:search] && params[:page].nil?
      SearchHistory.from_search(params[:search], current_user)
    end


    @restaurant = WillPaginate::Collection.create(params[:page] || 1, @preference['restaurant_per_page'] || 5, raw_results.length) do |pager|
      pager.replace raw_results[pager.offset, pager.per_page].to_a
    end

    # Use of Review.all will have performance issues, which is not preferred
    # For now, apply cache mechanism
    @reviews = Review.get_all_reviews
  end

  def search_aggregated
    # byebug
    @preference = get_preference

    @raw_results = Restaurant.custom_search(params[:search], @preference)

    @restaurant = WillPaginate::Collection.create(params[:page] || 1, @preference['restaurant_per_page'] || 5, @raw_results.length) do |pager|
      pager.replace @raw_results[pager.offset, pager.per_page].to_a
    end

    file = File.new(Rails.root.join('public', 'test.xml'), "wb")
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.markers {
        @restaurant.each_with_index do |rest, i|
          xml.marker("id" => i+1, "name" => rest.name, "address" => rest.address, "lat" => rest.coordinates.tr('[]', '').split(',').map(&:to_f)[0], "lng" => rest.coordinates.tr('[]', '').split(',').map(&:to_f)[1])
        end
      }
    end.to_xml
    file.write builder
    file.close
    # byebug
  end


  def aggregated
    file = File.new(Rails.root.join('public', 'test.xml'), "wb")

    @preference = get_preference
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).all.order("name ASC")

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.markers {
        @restaurant.each_with_index do |rest, i|
          xml.marker("id" => i+1, "name" => rest.name, "address" => rest.address, "lat" => rest.coordinates.tr('[]', '').split(',').map(&:to_f)[0], "lng" => rest.coordinates.tr('[]', '').split(',').map(&:to_f)[1])
        end
      }
    end.to_xml
    file.write builder
    file.close
  end

  def show
    id = params[:id]
    @restaurant = Restaurant.find(id)
    @preference = get_preference
    @reviews = Review.get_all_reviews
    @open_hour = @restaurant.open_hour
    if (@open_hour)
      orig = @open_hour.to_s
      @hash = orig.split(',')
      @hash.each do |day|
        if (day.include? "{")
          day.reverse!.chop!.reverse!
        end
        if (day.include? "}")
          day.chop!
        end
        day.gsub!("=>", " : ")
        day.gsub!(/"/, "  ")
        day.gsub!("_", " ")
      end
    end
  end


  private

  def get_preference

    preference = {}
    raw = current_user.preference
    unless raw.nil?
      preference['rating'] = raw.show_rating
      preference['reviews'] = raw.show_reviews
      preference['discount'] = raw.show_discount
      preference['popular'] = raw.show_popular_time
      preference['restaurant_per_page'] = raw.restaurants_per_page
      preference['weight_price'] = raw.price
      preference['weight_discount'] = raw.discount
      preference['weight_popularity'] = raw.popularity
      preference['weight_rating'] = raw.rating
      preference['weight_crowded'] = raw.crowded
    end
    preference['restaurant_per_page'] ||= 5
    preference['weight_price'] ||= 2
    preference['weight_discount'] ||= 2
    preference['weight_popularity'] ||= 2
    preference['weight_rating'] ||= 2
    preference['weight_crowded'] ||= 2

    # byebug
    preference
  end


  def valid_user_id
    # byebug
    unless current_user && params[:user_id].present? && current_user.id.to_s == params[:user_id]
      flash[:danger] = 'You are not authorized to access this page. Redirecting you to home/profile page'
      redirect_to login_path
    end
  end

  def validate_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to login_path
    end
  end




end