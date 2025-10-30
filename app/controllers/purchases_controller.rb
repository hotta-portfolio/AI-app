class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_knowhow, only: [ :new, :create, :confirm ]

  def index
    @purchases = current_user.purchases.includes(:knowhow)
  end

  # Stripe 公開鍵をJSに渡す
  def new
    @stripe_public_key = ENV["STRIPE_PUBLIC_KEY"]
  end

  # PaymentIntent を作成して client_secret を返す
  def create
    @payment = current_user.payment || current_user.build_payment

    # Stripe Customerが無ければ作成
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


  # 決済完了後にJSから呼び出される（DB保存＋カード情報登録）
  def confirm
    payment_intent_id = params[:payment_intent_id]

    # Stripe上のPaymentIntentを取得
    payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)

    if payment_intent.status == "succeeded"
      payment_method_id = payment_intent.payment_method

      # 🧩 ① Paymentレコードを確認 or 作成
      payment = current_user.payment || current_user.build_payment

      # 🧩 ② Stripe Customer を初回のみ作成
      if payment.stripe_customer_id.blank?
        customer = Stripe::Customer.create(
          email: current_user.email,
          payment_method: payment_method_id
        )
        payment.update!(stripe_customer_id: customer.id)
      end

      # 🧩 ③ PaymentMethod を Customer に紐付け
      Stripe::PaymentMethod.attach(
        payment_method_id,
        { customer: payment.stripe_customer_id }
      )

      # 🧩 ④ 二重購入チェック
      if Purchase.exists?(stripe_payment_intent_id: payment_intent_id)
        render json: { success: true, redirect_url: chat_room_path(@knowhow.chat_room) }
        return
      end

      # 🧩 ⑤ 購入情報を保存
      @purchase = current_user.purchases.new(
        knowhow: @knowhow,
        stripe_payment_intent_id: payment_intent_id,
        stripe_payment_method_id: payment_method_id
      )

      if @purchase.save
        render json: { success: true, redirect_url: chat_room_path(@knowhow.chat_room) }
      else
        render json: { success: false, error: "購入の保存に失敗しました" }
      end
    else
      render json: { success: false, error: "決済が完了していません（status: #{payment_intent.status}）" }
    end
  rescue Stripe::StripeError => e
    render json: { success: false, error: e.message }
  end

  private

  def set_knowhow
    @knowhow = Knowhow.find(params[:knowhow_id])
  end
end
