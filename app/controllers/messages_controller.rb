# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.create!(
      chat_room_id: params[:chat_room_id],
      content: params[:message][:content]
    )

    # ✅ ChatRoomChannel にブロードキャスト
    ChatRoomChannel.broadcast_to(
      @message.chat_room,
      message: render_message(@message)
    )

    head :ok
  end

  private

  # メッセージを partial としてレンダリング
  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message, current_user_loc: message.user }
    )
  end
end
