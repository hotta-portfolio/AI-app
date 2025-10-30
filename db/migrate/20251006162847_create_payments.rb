class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :card_number
      t.string :expiry_date
      t.string :cvc

      t.timestamps
    end
  end
end
