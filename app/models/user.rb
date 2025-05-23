class User < ApplicationRecord
  # Deviseの設定（認証関連）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :knowhows, dependent: :destroy
  has_many :purchases, dependent: :destroy
end
