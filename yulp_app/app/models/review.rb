
require 'yelp_client.rb'
require 'restaurant.rb'

class Review < ApplicationRecord
  belongs_to :restaurant

  # The method is to get review from yelp review api and store the reviews in each restaurant
  def self.getReview
    Restaurant.all.each do |rest|
      id = rest.name_id

      hash = YelpClient.review(id)
      hash["reviews"].each do |r|
        review = Review.new
        review.rating = r["rating"]
        review.user_image_url = r["user"]["image_url"]
        review.user_name = r["user"]["name"]
        review.text = r["text"]
        review.time_created = r["time_created"]
        review.review_url = r["url"]
        review.restaurant_id = rest.id

        review.save
      end
    end
  end
end
