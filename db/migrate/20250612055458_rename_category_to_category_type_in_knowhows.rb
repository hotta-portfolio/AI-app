class RenameCategoryToCategoryTypeInKnowhows < ActiveRecord::Migration[8.0]
  def change
    rename_column :knowhows, :category, :category_type
  end
end
