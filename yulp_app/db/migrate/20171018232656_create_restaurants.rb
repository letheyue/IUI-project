class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :image_url
      t.string :url
      t.string :review_count
      t.string :categories
      t.float :rating
      t.string :coordinates
      t.string :price
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :country
      t.string :state
      t.string :phone

      t.timestamps
    end
  end
end
