
require 'yelp_client.rb'
# require 'restaurant.rb'

class Review < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  self.table_name = "reviews"

  # The method is to get review from yelp review api and store the reviews in each restaurant
  def self.get_review_once

    @fetched ||= Review.all.present?
    if @fetched
      return
    end

    Restaurant.all.each do |rest|
      id = rest.name_id

      default_user_id = (User.find_by name: 'admin').id

      hash = YelpClient.review(id)

      # Add Error Checking Here:
      reviews = hash["reviews"]
      unless reviews.nil?
        reviews.each do |r|
          review = Review.new
          review.rating = r["rating"]
          review.user_image_url = r["user"]["image_url"]
          review.user_name = r["user"]["name"]
          review.text = r["text"]
          review.time_created = r["time_created"]
          review.review_url = r["url"]
          review.restaurant_id = rest.id
          review.user_id = default_user_id
          review.save
        end
      end
    end

    @fetched = true
  end




  def self.get_all_reviews
    # Apply Cache
    unless @results
      @results = Review.all
    end
    return @results
  end



end
