class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_knowhow

  def new
    # 購入確認画面用の処理（Stripeのpublishable_keyを渡したい場合ここでセット）
    @stripe_public_key = Rails.application.credentials.dig(:stripe, :public_key)
  end

  def create
    token = params[:stripe_token]

    begin
      # 例: 料金はKnowhowモデルに price カラムがある前提で、単位は円
      amount = (@knowhow.price * 100).to_i  # Stripeは「最小通貨単位」なので円→セント換算（JPYはセントなしだけど100掛けて整数化するのが普通）

      charge = Stripe::Charge.create(
        amount: amount,
        currency: 'jpy',
        source: token,
        description: "Knowhow purchase: #{@knowhow.title} by user #{current_user.id}"
      )

      # 決済成功したら購入レコードを作成
      @purchase = current_user.purchases.new(knowhow: @knowhow, stripe_charge_id: charge.id)

      if @purchase.save
        redirect_to chat_room_path(@purchase.chat_room), notice: "購入が完了しました。チャットルームに移動します。"
      else
        flash.now[:alert] = "購入に失敗しました。"
        render :new
      end

    rescue Stripe::CardError => e
      flash.now[:alert] = e.message
      render :new
    end
  end

  private

  def set_knowhow
    @knowhow = Knowhow.find(params[:knowhow_id])
  end
end
