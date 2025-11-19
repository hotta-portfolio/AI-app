class AddPurchaseToChatRooms < ActiveRecord::Migration[8.0]
  def change
    add_reference :chat_rooms, :purchase, null: false, foreign_key: true
  end
end
