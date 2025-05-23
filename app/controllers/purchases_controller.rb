class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_knowhow

  def new
    # 購入確認画面用の処理
  end

  def create
    @purchase = current_user.purchases.new(knowhow: @knowhow)

    if @purchase.save
      redirect_to chat_room_path(@purchase.chat_room), notice: "購入が完了しました。チャットルームに移動します。"
    else
      flash.now[:alert] = "購入に失敗しました。"
      render :new
    end
  end

  private

  def set_knowhow
    @knowhow = Knowhow.find(params[:knowhow_id])
  end
end
