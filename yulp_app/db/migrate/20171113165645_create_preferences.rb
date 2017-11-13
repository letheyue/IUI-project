class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preferences, id: false do |t|
      t.integer :user_id, null: false
      t.integer :price
      t.integer :discount
      t.integer :popularity
      t.integer :rating
      t.integer :crowded
      t.boolean :show_rating
      t.boolean :show_reviews
      t.boolean :show_discount
      t.boolean :show_popular_time
      t.integer :restaurants_per_page

      t.timestamps
    end
    add_index :preferences, :user_id, unique: true
  end
end
