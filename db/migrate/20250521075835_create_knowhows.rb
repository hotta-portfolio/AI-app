class CreateKnowhows < ActiveRecord::Migration[8.0]
  def change
    create_table :knowhows do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :price
      t.text :content

      t.timestamps
    end
  end
end
