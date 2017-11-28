class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|

      t.string  :subject
      t.text    :content

      t.timestamps
    end
    add_reference :feedbacks, :user, foreign_key: true

  end
end
