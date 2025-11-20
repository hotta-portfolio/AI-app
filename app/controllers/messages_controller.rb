class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.create!(
      chat_room_id: params[:chat_room_id],
      content: params[:message][:content]
    )

    # ActionCable broadcast
    ChatRoomChannel.broadcast_to(
      @message.chat_room,
      message: render_message(@message)
    )

    # Turbo対応: HTML送信ならリダイレクト、fetch(JSON)ならJSONを返す
    respond_to do |format|
      format.json { render json: { message: render_message(@message) } }
      format.html { redirect_to @message.chat_room }
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message, current_user_loc: current_user }
    )
  end
end
