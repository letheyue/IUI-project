require 'yelp_client.rb'
require 'google_client.rb'

class Restaurant < ActiveRecord::Base
  self.table_name = "restaurants"

  @whole_information = YelpClient.search({})
  @size = @whole_information["businesses"].size
  @business = @whole_information["businesses"]


  def self.trim_to_empty(str)
    if str.nil?
      return ''
    end
    str
  end

  def self.name
    name = Array.new(@size)
    index = 0
    @business.each do |n|
      name[index] = n["name"]
      index = index + 1
    end
    name
  end

  def self.address
    address = Array.new(@size)
    index = 0
    @business.each do |a|
      hash = a["location"]
      if (hash["address1"] != "" && hash["address1"] != nil)
        address[index] = hash["address1"] + " "
      end
      if (hash["address2"] != "" && hash["address2"] != nil)
        address[index] = address[index] + hash["address2"] + " "
      end
      if (hash["address3"] != "" && hash["address3"] != nil)
        address[index] = address[index] + hash["address3"]
      end
      index = index + 1
    end
    address
  end

  def self.get_all_popular_times(names, addresses)
    places = names.zip(addresses).to_h
    # byebug
    result_hash = Hash.new
    GoogleClient.get_all_popular_times(places).each do |name, result|
      one_place_result = Hash.new
      result.each do |day, times|
        hash_times = Hash.new
        times.each_with_index do |time, index|
          hash_times[(index+7).modulo(24)] = time
        end
        one_place_result[day] = hash_times
      end
      result_hash[name] = one_place_result
    end
    result_hash
  end

  # Note: This function will only fetch data once
  #   address can be nil
  #   popular_times can be nil
  #   each element in popular_times Hash can be nil
  def self.setup_table_once

    @fetched ||= Restaurant.all.present?
    if @fetched
      return
    end

    names = Restaurant.name
    addresses = Restaurant.address
    popular_times = Restaurant.get_all_popular_times(names, addresses)

    @business.each do |business|

      restaurant = Restaurant.new
      restaurant.name_id = business["id"]
      current_instance = Restaurant.find_by name_id: business["id"]
      if current_instance
        restaurant = current_instance
      else
        restaurant.name = business["name"]
        restaurant.image_url = business["image_url"]
        restaurant.url = business["url"]
        restaurant.review_count = business["review_count"]
        restaurant.rating = business["rating"]
        restaurant.phone = business["phone"]
        restaurant.price = business["price"]

        # Category will be saved later in model
        restaurant.categories = business["categories"]

        coordinate = Array.new
        coordinate << business["coordinates"]["latitude"]
        coordinate << business["coordinates"]["longitude"]
        restaurant.coordinates = coordinate

        location = business["location"]
        address = trim_to_empty(location["address1"]) + trim_to_empty(location["address2"]) + trim_to_empty(location["address3"])
        restaurant.address = address
        restaurant.city = location["city"]
        restaurant.zip_code = location["zip_code"]
        restaurant.country = location["country"]
        restaurant.state = location["state"]

        restaurant.popular_times = popular_times[restaurant.name]

        restaurant.save!
      end

    end

    @fetched = true
  end

end
