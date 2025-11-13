class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_knowhow, only: [ :new, :create, :confirm ]

  def index
    @purchases = current_user.purchases.includes(:knowhow).order(created_at: :desc)
  end

  # Stripe 公開鍵をJSに渡す
  def new
    @stripe_public_key = ENV["STRIPE_PUBLIC_KEY"]
  end

  # PaymentIntent を作成して client_secret を返す
  def create
    @payment = current_user.payment || current_user.build_payment

    # Stripe Customer が無ければ作成
    if @payment.stripe_customer_id.blank?
      customer = Stripe::Customer.create(email: current_user.email)
      @payment.update!(stripe_customer_id: customer.id)
    end

    amount = (@knowhow.price * 100).to_i

    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: "jpy",
      customer: @payment.stripe_customer_id,
      payment_method_types: [ "card" ],
      metadata: { knowhow_id: @knowhow.id, user_id: current_user.id }
    )

    render json: { client_secret: payment_intent.client_secret }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # 決済完了後にJSから呼ばれる（DB保存＋ChatRoom作成）
  def confirm
    payment_intent_id = params[:payment_intent_id]
    payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)

    unless payment_intent.status == "succeeded"
      render json: { success: false, error: "決済が完了していません（status: #{payment_intent.status}）" }
      return
    end

    payment_method_id = payment_intent.payment_method
    payment = current_user.payment || current_user.build_payment

    # 初回のみ Stripe Customer 作成
    if payment.stripe_customer_id.blank?
      customer = Stripe::Customer.create(
        email: current_user.email,
        payment_method: payment_method_id
      )
      payment.update!(stripe_customer_id: customer.id)
    end

    # PaymentMethod を Customer に紐付け
    Stripe::PaymentMethod.attach(
      payment_method_id,
      { customer: payment.stripe_customer_id }
    )

    # 二重購入チェック
    @purchase = Purchase.find_or_initialize_by(stripe_payment_intent_id: payment_intent_id) do |p|
      p.user = current_user
      p.knowhow = @knowhow
      p.stripe_payment_method_id = payment_method_id
    end

    if @purchase.new_record?
      unless @purchase.save
        render json: { success: false, error: "購入の保存に失敗しました" }
        return
      end
    end

    # ChatRoom 作成（Purchase に紐付け）
    chat_room = ChatRoom.find_or_create_by!(knowhow: @knowhow, purchase: @purchase)

    render json: { success: true, redirect_url: chat_room_path(chat_room) }
  rescue Stripe::StripeError => e
    render json: { success: false, error: e.message }
  end

  private

  def set_knowhow
    @knowhow = Knowhow.find(params[:knowhow_id])
  end
end
