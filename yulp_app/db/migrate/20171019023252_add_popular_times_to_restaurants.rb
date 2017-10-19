class AddPopularTimesToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :popular_times, :text
  end
end
