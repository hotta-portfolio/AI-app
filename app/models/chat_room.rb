class ChatRoom < ApplicationRecord
  belongs_to :purchase
  belongs_to :knowhow
  has_many :messages, dependent: :destroy
end
