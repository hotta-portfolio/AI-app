class CreatePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :knowhow, null: false, foreign_key: true

      t.timestamps
    end
  end
end
