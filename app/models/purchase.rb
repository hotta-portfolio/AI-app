class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :knowhow
  has_one :chat_room
end
