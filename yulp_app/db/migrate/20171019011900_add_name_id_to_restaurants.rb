class AddNameIdToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :name_id, :string
    add_index :restaurants, :name_id, unique: true
  end

end
