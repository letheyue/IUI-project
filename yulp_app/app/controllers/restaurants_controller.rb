require 'nokogiri'

class RestaurantsController < ApplicationController
  include SessionsHelper
  before_action :validate_login
  # before_action :valid_user_id

  def index
    @reviews = Review.all
    @preference = get_preference
    @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).all.order("name ASC")
    @reviews = Review.all
  end

  def search
    # @restaurant = Restaurant.all.order("name ASC").page params[:page]
    @preference = get_preference
    if params[:search]
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).search(params[:search])
    else
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).all.order("name ASC")
    end
  end

  def search_aggregated
    # byebug
    @preference = get_preference

    if params[:search]
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).search(params[:search])
    else
      @restaurant = Restaurant.paginate(:page => params[:page],:per_page => @preference['restaurant_per_page']).all.order("name ASC")
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
    # render 'aggregated'

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




  private

  def get_preference

    preference = {}
    raw = current_user.preference
    unless raw.nil?
      preference['rating'] = raw.show_rating
      preference['reviews'] = raw.show_reviews
      preference['discount'] = raw.show_discount
      preference['popular'] = raw.show_popular_time
      preference['restaurant_per_page'] = raw.restaurants_per_page || 5
    end
    preference['restaurant_per_page'] ||= 5
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