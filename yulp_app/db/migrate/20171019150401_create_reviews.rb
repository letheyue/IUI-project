class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.float :rating
      t.string :user_image_url
      t.string :user_name
      t.text :text
      t.string :time_created
      t.string :review_url

      t.timestamps
    end
  end
end
