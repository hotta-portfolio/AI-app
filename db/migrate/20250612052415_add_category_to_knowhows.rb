class AddCategoryToKnowhows < ActiveRecord::Migration[8.0]
  def change
    add_column :knowhows, :category, :integer, null: false, default: 0
  end
end
