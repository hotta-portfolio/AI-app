class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_knowhow

  def new
    @stripe_public_key = ENV['STRIPE_PUBLIC_KEY']
  end
  

  def create
    token = params[:stripe_token]
  
    begin
      amount = (@knowhow.price * 100).to_i
  
      charge = Stripe::Charge.create(
        amount: amount,
        currency: 'jpy',
        source: token,
        description: "Knowhow purchase: #{@knowhow.title} by user #{current_user.id}"
      )
  
      @purchase = current_user.purchases.new(knowhow: @knowhow, stripe_charge_id: charge.id)
  
      if @purchase.save
        @chat_room = @purchase.create_chat_room(knowhow: @knowhow)
        redirect_to chat_room_path(@chat_room), notice: "購入が完了しました。チャットルームに移動します。"
      else
        flash.now[:alert] = "購入に失敗しました。"
        redirect_to new_knowhow_purchase_path(@knowhow)
      end
  
    rescue Stripe::CardError => e
      flash.now[:alert] = e.message
      redirect_to new_knowhow_purchase_path(@knowhow)
    end
  end
  

  private

  def set_knowhow
    @knowhow = Knowhow.find(params[:knowhow_id])
  end
end
