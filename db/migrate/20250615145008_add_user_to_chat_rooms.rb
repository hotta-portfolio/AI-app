class AddUserToChatRooms < ActiveRecord::Migration[8.0]
  def change
    add_reference :chat_rooms, :user, foreign_key: true
  end
end
