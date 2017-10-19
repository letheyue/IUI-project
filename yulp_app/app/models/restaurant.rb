require 'yelp_client.rb'
require 'google_client.rb'

class Restaurant < ActiveRecord::Base
  self.table_name = "restaurants"

  @whole_information = YelpClient.search({})


  # Note:
  #   address can be nil
  #   popular_times can be nil
  #   each element in popular_times Hash can be nil
  def self.setupTable
    name_ids = Restaurant.name_id
    names = Restaurant.name
    image_urls = Restaurant.image_url
    urls = Restaurant.url
    review_counts = Restaurant.review_count
    categories = Restaurant.category
    ratings = Restaurant.rating
    coordinates = Restaurant.coordinate
    prices = Restaurant.price
    addresses = Restaurant.address
    cities = Restaurant.city
    zip_codes = Restaurant.zip_code
    countries = Restaurant.country
    states = Restaurant.state
    phones = Restaurant.phone

    byebug
    popular_times = Restaurant.get_all_popular_times(names, addresses)


    @size = @whole_information["businesses"].size
    i = 0
    while i < @size do
      restaurant = Restaurant.new
      restaurant.name_id = name_ids.at(i)
      restaurant.name = names.at(i)
      restaurant.image_url = image_urls.at(i)
      restaurant.url = urls.at(i)
      restaurant.review_count = review_counts.at(i)
      restaurant.categories = categories.at(i)
      restaurant.rating = ratings.at(i)
      restaurant.coordinates = coordinates.at(i)
      restaurant.price = prices.at(i)
      restaurant.address = addresses.at(i)
      restaurant.city = cities.at(i)
      restaurant.zip_code = zip_codes.at(i)
      restaurant.country = countries.at(i)
      restaurant.state = states.at(i)
      restaurant.phone = phones.at(i)

      restaurant.popular_times = popular_times.at(i)


      restaurant.save
      i = i + 1
    end


  end

  def self.name_id
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    name_id = Array.new(@size)
    index = 0
    @business.each do |id|
      name_id[index] = id["id"]
      index = index + 1
    end
    name_id
  end

  def self.name
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    name = Array.new(@size)
    index = 0
    @business.each do |n|
      name[index] = n["name"]
      index = index + 1
    end
    name
  end

  def self.image_url
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    image_url = Array.new(@size)
    index = 0
    @business.each do |image|
      image_url[index] = image["image_url"]
      index = index + 1
    end
    image_url
  end

  def self.url
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    url = Array.new(@size)
    index = 0
    @business.each do |u|
      url[index] = u["url"]
      index = index + 1
    end
    url
  end

  def self.review_count
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    review_count = Array.new(@size)
    index = 0
    @business.each do |count|
      review_count[index] = count["review_count"]
      index = index + 1
    end
    review_count
  end

  def self.phone
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    phone = Array.new(@size)
    index = 0
    @business.each do |p|
      phone[index] = p["display_phone"]
      index = index + 1
    end
    phone
  end

  def self.price
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    prices = Array.new(@size)
    index = 0
    @business.each do |price|
      prices[index] = price["price"]
      index = index + 1
    end
    prices
  end

  def self.rating
    ratings = Array.new(@size)
    index = 0
    @business.each do |rating|
      ratings[index] = rating["rating"]
      index = index + 1
    end
    ratings
  end

  def popular_time

  end

  def self.coordinate
    coordinates = Array.new(@size)
    index = 0
    @business.each do |coordinate|
      hash = coordinate["coordinates"]
      coordinates[index] = Array.new(2)
      coordinates[index][0] = hash["latitude"]
      coordinates[index][1] = hash["longitude"]
      index = index + 1
    end

    coordinates
  end

  def self.category
    categories = Array.new(@size)
    index = 0
    @business.each do |category|
      hash = category["categories"]
      categories[index] = Array.new(hash.size)
      i = 0
      hash.each do |one|
        categories[index][i] = one["title"]
        i = i + 1
      end
      index = index + 1
    end

    categories
  end

  def self.address
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
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

  def self.city
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    city = Array.new(@size)
    index = 0
    @business.each do |c|
      hash = c["location"]
      city[index] = hash["city"]
      index = index + 1
    end
    city
  end

  def self.zip_code
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    zip_code = Array.new(@size)
    index = 0
    @business.each do |c|
      hash = c["location"]
      zip_code[index] = hash["zip_code"]
      index = index + 1
    end
    zip_code
  end

  def self.country
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    country = Array.new(@size)
    index = 0
    @business.each do |c|
      hash = c["location"]
      country[index] = hash["country"]
      index = index + 1
    end
    country
  end

  def self.state
    @size = @whole_information["businesses"].size
    @business = @whole_information["businesses"]
    state = Array.new(@size)
    index = 0
    @business.each do |s|
      hash = s["location"]
      state[index] = hash["state"]
      index = index + 1
    end
    state
  end

  def self.get_all_popular_times(names, addresses)
    places = names.zip(addresses).to_h
    # byebug
    result_array = Array.new
    GoogleClient.get_all_popular_times(places).each do |name, result|
      one_place_result = Hash.new
      result.each do |day, times|
        hash_times = Hash.new
        times.each_with_index do |times, index|
          hash_times[(index+7).modulo(24)] = times
        end
        one_place_result[day] = hash_times
      end
      result_array << one_place_result
    end
    result_array
  end


  def learn()

  end

end
