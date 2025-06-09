class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :knowhow
  has_one :chat_room, dependent: :destroy

  after_create :create_chat_room

  private

  def create_chat_room
    ChatRoom.create!(purchase: self, knowhow: self.knowhow)
  end
end
