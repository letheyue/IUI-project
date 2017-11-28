class CreateSearchHistoryForUser < ActiveRecord::Migration[5.0]
  def change
    create_table :search_histories do |t|

      t.string :query_term, unique: true
      t.integer :times

      t.timestamps

    end
    add_reference :search_histories, :user, foreign_key: true

  end
end
