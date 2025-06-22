class ChatRoom < ApplicationRecord
  belongs_to :knowhow
  has_many :messages, dependent: :destroy

  scope :rooms_for, ->(role, user_id) {
    case role
    when "buyer"
      joins(knowhow: :purchases).where(purchases: { user_id: })
    when "seller"
      joins(:knowhow).where(knowhows: { user_id: })
    else
      buyer_knowhow_ids = Knowhow.where(user_id: user_id).ids
      seller_knowhow_ids = Purchase.where(user_id: user_id).pluck(:knowhow_id)
      knowhow_ids = (seller_knowhow_ids + buyer_knowhow_ids).uniq
      joins(:knowhow).where(knowhow: { id: knowhow_ids })
    end.includes(knowhow: :purchases)
       .distinct
       .order(id: :desc)
  }
end
