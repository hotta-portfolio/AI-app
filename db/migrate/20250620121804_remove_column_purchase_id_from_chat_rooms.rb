class RemoveColumnPurchaseIdFromChatRooms < ActiveRecord::Migration[8.0]
  def change
    remove_column :chat_rooms, :purchase_id, :bigint
  end
end
