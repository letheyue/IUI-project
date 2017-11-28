
require 'yelp_client.rb'
require 'crawler_client.rb'
require 'category.rb'

class Restaurant < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  has_and_belongs_to_many :categories


  self.table_name = "restaurants"

  def trim_to_empty(str)
    if str.nil?
      return ''
    end
    str
  end

  def names
    name = Array.new(@size)
    index = 0
    @business.each do |n|
      name[index] = n["name"]
      index = index + 1
    end
    name
  end

  def addresses
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

  def add_open_hour(id)
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

  def get_all_popular_times(names, addresses)
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

  def get_all_discount_info(names, addresses)
    places = names.zip(addresses).to_h
    CrawlerClient.get_all_discount_info(places)
  end


  # Note: This function will only fetch data once
  # Then create the Restaurant & Categories table
  #   address can be nil
  #   popular_times can be nil
  #   each element in popular_times Hash can be nil
  def self.setup_table_once

    @whole_information = YelpClient.search({})
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]

    @fetched ||= Restaurant.all.present?
    if @fetched
      return
    end

    names = Restaurant.name
    addresses = Restaurant.addresses
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

        restaurant.popular_times = popular_times[restaurant.names]
        restaurant.discount = discounts[restaurant.names]

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


  # The following is for Data Manipulation

  def self.search(search)
    search = search.downcase.gsub(/\-/, '')
    where("lower(name) LIKE ? OR lower(address) LIKE ? OR lower(city) LIKE ? OR lower(zip_code) LIKE ? OR lower(phone) LIKE ?", "%#{search}%", "%#{search}%","%#{search}%", "%#{search}%", "%#{search}%")
  end


  def self.custom_search( search_str, preference)
    # Apply cache technique
    # Do not cache if search_str == nil
    #   => Otherwise it will cache all the restaurants
    if @term &&  (search_str && @term == search_str)
      logger.info('Same Term Encountered.')
      return @raw_results
    else
<<<<<<< HEAD
      @raw_results = Restaurant.search(search_str || '').sort{ |a,b|
        calculate_overall_weight_for_restaurant(b, preference) <=> calculate_overall_weight_for_restaurant(a, preference)
      }
=======
      @raw_results = Restaurant.search(search_str || '').sort{ |a,b| b.rating.to_f <=> a.rating.to_f}
>>>>>>> Implement Custom Comparator
      if search_str
        @term = search_str
      else
        @term = ''
      end

      logger.info("Term is:#{@term}")
      return @raw_results
    end
  end

  def self.calculate_overall_weight_for_restaurant (restaurant, prefer)
  # byebug
    if restaurant.price.size != 0
      result = (restaurant.rating.to_f * prefer['weight_rating'] * 1 + (5-restaurant.price.size) * prefer['weight_price'] + restaurant.discount.to_f / 40 * prefer['weight_discount'] )
    else
      result = (restaurant.rating.to_f * prefer['weight_rating'] * 1 + 3 * prefer['weight_price'] +restaurant.discount.to_f / 40 * prefer['weight_discount'] )
    end
    result

  end








end
