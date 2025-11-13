class ChatRoom < ApplicationRecord
  belongs_to :knowhow
  belongs_to :purchase
  has_many :messages, dependent: :destroy

  scope :rooms_for, ->(role, user_id) {
    case role
    when "buyer"
      joins(knowhow: :purchases).where(purchases: { user_id: user_id })
    when "seller"
      joins(:knowhow).where(knowhows: { user_id: user_id })
    else
      none
    end
      .includes(knowhow: :purchases)
      .distinct
      .order(id: :desc)
  }
end
