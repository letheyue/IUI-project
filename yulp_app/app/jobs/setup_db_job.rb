require 'restaurant.rb'

class SetupDbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Restaurant.setup_table_once
  end
end
