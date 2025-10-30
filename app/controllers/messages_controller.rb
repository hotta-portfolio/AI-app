class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create!(
      chat_room_id: params[:chat_room_id],
      content: params[:message][:content]
    )

    ActionCable.server.broadcast(
      "chat_room_#{@message.chat_room_id}",
      { message: render_message(@message) }
    )
    head :ok
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message, current_user_loc: message.user }
      # current_user_loc にメッセージ送信者を渡す
    )
  end
end
