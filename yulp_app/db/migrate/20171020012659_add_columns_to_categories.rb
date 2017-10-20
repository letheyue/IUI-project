class AddColumnsToCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :categories, :name, :string
    rename_column :categories, :description, :alias
    add_column :categories, :title, :string, null: false, unique: true
    add_index :categories, :title
  end
end
