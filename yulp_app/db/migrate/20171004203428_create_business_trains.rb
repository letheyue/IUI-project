class CreateBusinessTrains < ActiveRecord::Migration[5.0]
  def change
    create_table :business_trains do |t|
      t.string    :name
      t.float     :price
      t.float     :rating
      t.float     :crowd
      t.float     :discount
      # t.timestamps
    end
  end
end
