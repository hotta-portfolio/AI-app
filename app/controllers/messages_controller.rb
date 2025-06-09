class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create!(
      chat_room_id: params[:chat_room_id],
      content: params[:message][:content]
    )

    ActionCable.server.broadcast(
      "chat_room_#{@message.chat_room_id}",
      content: render_message(@message)
    )
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: "chat_room_messages/message", locals: { message: message })
  end
end

