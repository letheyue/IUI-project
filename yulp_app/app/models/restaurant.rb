
require 'yelp_client.rb'
require 'crawler_client.rb'
require 'category.rb'

class Restaurant < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  has_and_belongs_to_many :categories

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
      hash = a['location']
      address[index] = ''
      unless hash.nil?
        unless hash['address1'].nil?
          address[index] += hash['address1'] + ' '
        end
        unless hash['address2'].nil?
          address[index] += hash['address2'] + ' '
        end
        unless hash['address3'].nil?
          address[index] += hash['address3'] + ' '
        end
      end
      index = index + 1
    end
    address
  end

  def self.add_open_hour(id)
    hash = YelpClient.business(id)
    open_hour = Hash.new

    if (hash["hours"] != nil)

      hash["hours"][0]["open"].each do |day|
        s = day["day"]
        if (s == 0)
          d = 'Monday'
        end
        if (s == 1)
          d = 'Tuesday'
        end
        if (s == 2)
          d = 'Wednesday'
        end
        if (s == 3)
          d = 'Thursday'
        end
        if (s == 4)
          d = 'Friday'
        end
        if (s == 5)
          d = 'Saturday'
        end
        if (s == 6)
          d = 'Sunday'
        end

        open_hour[d] = 'start_time: ' + day["start"] + ' ' + 'close_time: ' + day["end"]
      end
    end
    open_hour
  end

  def self.get_all_popular_times(names, addresses)
    places = names.zip(addresses).to_h
    # byebug
    result_hash = Hash.new
    CrawlerClient.get_all_popular_times(places).each do |name, result|
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

  def self.get_all_discount_info(names, addresses)
    places = names.zip(addresses).to_h
    CrawlerClient.get_all_discount_info(places)
  end


  # Note: This function will only fetch data once
  # Then create the Restaurant & Categories table
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
    discounts = Restaurant.get_all_discount_info(names, addresses)

    @business.each do |business|

      restaurant = Restaurant.new
      restaurant.name_id = business["id"]
      current_instance = Restaurant.find_by name_id: business["id"]
      if current_instance
        restaurant = current_instance
      else
        restaurant.name = business["name"]
        restaurant.image_url = business["image_url"] || ''
        restaurant.url = business["url"] || ''
        restaurant.review_count = business["review_count"] || ''
        restaurant.rating = business["rating"]
        restaurant.phone = business["phone"] || ''
        restaurant.price = business["price"] || ''

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
        restaurant.discount = discounts[restaurant.name]

        restaurant.open_hour = Restaurant.add_open_hour(business["id"])

        restaurant.save!

        # Category is saved in its own Model
        business["categories"].each do |category_hash|
          category = Category.find_by title: category_hash["title"]
          unless category
            category = Category.new
            category.title = category_hash["title"]
            category.alias = category_hash["alias"]
            category.save!
          end
          category.restaurants << restaurant
        end
      end

    end

    @fetched = true
  end


end
