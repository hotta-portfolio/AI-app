class ChangePurchaseIdNullOnChatRooms < ActiveRecord::Migration[8.0]
  def change
    change_column_null :chat_rooms, :purchase_id, true
  end
end
