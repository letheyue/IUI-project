require 'restaurant.rb'
require 'review.rb'

class SetupDbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Restaurant.setup_table_once
    Review.get_review_once
  end
end
