class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:show]
  before_action :authorize_user!, only: [:show]

  def index
    case params[:role]
    when 'buyer'
      @chat_rooms = ChatRoom.joins(:purchase)
                            .where(purchases: { user_id: current_user.id })
                            .includes(:knowhow)
    when 'seller'
      @chat_rooms = ChatRoom.joins(:knowhow)
                            .where(knowhows: { user_id: current_user.id })
                            .includes(:purchase)
    else
      @chat_rooms = ChatRoom.joins(:purchase, :knowhow)
                            .where('purchases.user_id = :user_id OR knowhows.user_id = :user_id', user_id: current_user.id)
                            .distinct
                            .includes(:purchase, :knowhow)
    end
  end

  def show
    @message = Message.new
    @messages = @chat_room.messages.includes(:user)
  end

  # ここから追加
  def create
    knowhow = Knowhow.find(params[:knowhow_id])
    purchase = current_user.purchases.find_by(knowhow_id: knowhow.id)

    @chat_room = ChatRoom.find_or_create_by(
      knowhow: knowhow,
      purchase: purchase
    )

    redirect_to @chat_room
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def authorize_user!
    unless current_user.id == @chat_room.purchase&.user_id || current_user.id == @chat_room.knowhow.user_id
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end
