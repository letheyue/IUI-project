class AddDiscountToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :discount, :integer
  end
end
