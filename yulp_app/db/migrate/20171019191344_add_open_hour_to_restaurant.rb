class AddOpenHourToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :open_hour, :text
  end
end
