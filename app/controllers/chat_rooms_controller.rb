class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [ :show ]
  before_action :authorize_user!, only: [ :show ]

  def index
    if params[:role].present?
      # roleがある場合のみチャットルームを取得
      @chat_rooms = ChatRoom.rooms_for(params[:role], current_user.id)
    else
      # roleがない場合は空にして、最初はカードを非表示
      @chat_rooms = []
    end
  end

  def show
    @message = Message.new
    @messages = @chat_room.messages.includes(:user)

    # 出品者（Knowhowの投稿者）
    seller = @chat_room.knowhow.user

    # 購入者（そのKnowhowを購入したユーザー）
    buyer = @chat_room.knowhow.purchases.first&.user

    # 現在ログイン中のユーザーから見た相手
    @chat_partner =
      if current_user == seller
        buyer
      else
        seller
      end
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
    unless current_user.id == @chat_room.knowhow.purchases&.detect { |purchase| purchase.user_id == current_user.id }&.user_id || current_user.id == @chat_room.knowhow.user_id
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end
