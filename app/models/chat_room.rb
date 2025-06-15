class ChatRoom < ApplicationRecord
  belongs_to :knowhow
  belongs_to :user
  has_many :messages, dependent: :destroy
end
