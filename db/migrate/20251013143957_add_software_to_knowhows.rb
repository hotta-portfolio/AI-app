class AddSoftwareToKnowhows < ActiveRecord::Migration[8.0]
  def change
    add_column :knowhows, :software, :string
  end
end
