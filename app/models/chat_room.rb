class ChatRoom < ApplicationRecord
  belongs_to :purchase, optional: true
  belongs_to :knowhow
  has_many :messages, dependent: :destroy

  scope :rooms_for, ->(role, user_id) {
    case role
    when "buyer"
      joins(:purchase)
        .where(purchases: { user_id: })
        .includes(:knowhow)
    when "seller"
      joins(:knowhow)
        .where(knowhows: { user_id: })
        .includes(:purchase)
    else
      joins(:purchase, :knowhow)
        .where("purchases.user_id = :user_id OR knowhows.user_id = :user_id", user_id: user_id)
        .distinct
    end.order(id: :desc)
  }
end
