class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room
  before_action :authorize_user!

  def show
    @message = Message.new
    @messages = @chat_room.messages.includes(:user)
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def authorize_user!
    unless current_user.id == @chat_room.purchase.user_id || current_user.id == @chat_room.knowhow.user_id
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end
