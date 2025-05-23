class Knowhow < ApplicationRecord
  belongs_to :user
  has_many_attached :media_files
  has_many :purchases, dependent: :destroy
  has_one :chat_room
end
