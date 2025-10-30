class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment
  before_action :ensure_stripe_customer

  def show
    payment_methods = Stripe::PaymentMethod.list(
      customer: @payment.stripe_customer_id,
      type: "card"
    )

    if payment_methods.data.any?
      card = payment_methods.data.first.card
      @card_info = {
        brand: card.brand,
        last4: card.last4,
        exp_month: card.exp_month,
        exp_year: card.exp_year
      }
    else
      @card_info = nil
    end
  end

  private

  def set_payment
    @payment = current_user.payment || current_user.build_payment
  end

  # Stripe Customerが存在しなければ自動作成
  def ensure_stripe_customer
    if @payment.stripe_customer_id.present?
      begin
        Stripe::Customer.retrieve(@payment.stripe_customer_id)
      rescue Stripe::InvalidRequestError
        customer = Stripe::Customer.create(email: current_user.email)
        @payment.update!(stripe_customer_id: customer.id)
      end
    else
      customer = Stripe::Customer.create(email: current_user.email)
      @payment.update!(stripe_customer_id: customer.id)
    end
  end
end
