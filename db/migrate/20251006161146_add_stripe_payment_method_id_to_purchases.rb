class AddStripePaymentMethodIdToPurchases < ActiveRecord::Migration[8.0]
  def change
    add_column :purchases, :stripe_payment_method_id, :string
  end
end
