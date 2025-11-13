class AddStripePaymentIntentIdToPurchases < ActiveRecord::Migration[8.0]
  def change
    add_column :purchases, :stripe_payment_intent_id, :string
  end
end
