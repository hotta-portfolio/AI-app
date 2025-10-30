class AddStripeCustomerIdToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :stripe_customer_id, :string
  end
end
