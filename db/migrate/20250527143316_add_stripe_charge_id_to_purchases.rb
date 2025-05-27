class AddStripeChargeIdToPurchases < ActiveRecord::Migration[8.0]
  def change
    add_column :purchases, :stripe_charge_id, :string
  end
end
