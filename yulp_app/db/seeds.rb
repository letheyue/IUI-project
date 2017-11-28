require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create({:name => 'admin', :email => 'admin@sample.com', :password => '123456'})
user2 = User.create({:name => 'defaultUser', :email => 'default@sample.com', :password => '123456'})


# Load data from CSV file:
csv_categories = File.read(Rails.root.join('lib', 'seeds', 'categories.csv'))
CSV.parse(csv_categories, :headers => true, :encoding => 'ISO-8859-1').each do |row|
  c = Category.new
  c.alias = row['alias']
  c.title = row['title']
  c.save
end
csv_restaurants = File.read(Rails.root.join('lib', 'seeds', 'restaurants.csv'))
CSV.parse(csv_restaurants, :headers => true, :encoding => 'ISO-8859-1').each do |row|
  r = Restaurant.new
  r.name = row['name']
  r.image_url = row['image_url']
  r.url = row['url']
  r.review_count = row['review_count']
  r.rating = row['rating']
  r.coordinates = row['coordinates']
  r.price = row['price']
  r.address = row['address']
  r.city = row['city']
  r.zip_code = row['zip_code']
  r.country = row['country']
  r.state = row['state']
  r.phone = row['phone']
  r.name_id = row['name_id']
  r.popular_times = row['popular_times']
  r.open_hour = row['open_hour']
  r.discount = row['discount']
  r.save
end

csv_categories_restaurants = File.read(Rails.root.join('lib', 'seeds', 'categories_restaurants.csv'))

CSV.parse(csv_categories_restaurants, :headers => true, :encoding => 'ISO-8859-1').each do |row|
  restaurant_id = row['restaurant_id']
  category_id = row['category_id']
  Category.find(category_id).restaurants << Restaurant.find(restaurant_id)
end

csv_reviews = File.read(Rails.root.join('lib', 'seeds', 'reviews.csv'))

CSV.parse(csv_reviews, :headers => true, :encoding => 'ISO-8859-1').each do |r|
  review = Review.new
  review.rating = r['rating']
  review.user_image_url = r['user_image_url']
  review.user_name = r['user_name']
  review.text = r['text']
  review.time_created = r['time_created']
  review.review_url = r['review_url']
  review.restaurant_id = r['restaurant_id']
  review.user_id = r['user_id']
  review.save
end


