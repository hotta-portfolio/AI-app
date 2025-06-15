class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:show]
  before_action :authorize_user!, only: [:show]

  def index
    @chat_rooms = ChatRoom
      .includes(:knowhow)
      .where("chat_rooms.user_id = :id OR knowhows.user_id = :id", id: current_user.id)
      .references(:knowhow)
  end
  
  def show
    @message = Message.new
    @messages = @chat_room.messages.includes(:user)
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def authorize_user!
    unless current_user.id == @chat_room.user_id || current_user.id == @chat_room.knowhow.user_id
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end
