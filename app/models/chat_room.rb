class ChatRoom < ApplicationRecord
  belongs_to :purchase, optional: true
  belongs_to :knowhow
  has_many :messages, dependent: :destroy
end
