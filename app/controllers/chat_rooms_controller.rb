class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [ :show ]
  before_action :authorize_user!, only: [ :show ]

  # 購入者／販売者別のチャット一覧
  def index
    if params[:role].present?
      @chat_rooms = ChatRoom.rooms_for(params[:role], current_user.id)
    else
      @chat_rooms = []
    end
  end

  # チャット画面
  def show
    @message = Message.new
    @messages = @chat_room.messages.includes(:user)

    seller = @chat_room.knowhow.user
    buyer  = @chat_room.purchase.user

    @chat_partner = current_user == seller ? buyer : seller
  end

  # 新規チャット作成（購入済み Knowhow に紐付く場合のみ）
  def create
    knowhow = Knowhow.find(params[:knowhow_id])
    purchase = current_user.purchases.find_by(knowhow_id: knowhow.id)

    unless purchase
      redirect_to knowhow_path(knowhow), alert: "購入済みのコンテンツでのみチャット可能です"
      return
    end

    # 既存チャットがあれば取得、なければ作成
    @chat_room = ChatRoom.find_or_create_by!(
      knowhow: knowhow,
      purchase: purchase
    )

    redirect_to @chat_room
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find_by(id: params[:id])
    unless @chat_room
      redirect_to root_path, alert: "チャットルームが存在しません"
    end
  end

  def authorize_user!
    allowed_user_ids = [ @chat_room.purchase.user_id, @chat_room.knowhow.user_id ]
    unless allowed_user_ids.include?(current_user.id)
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end
