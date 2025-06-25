class User < ApplicationRecord
  # Deviseの設定（認証関連）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :knowhows, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :chat_rooms, through: :knowhows
  has_many :messages, dependent: :destroy

    # 🔒 検索可能なカラムを明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    %w[name email created_at updated_at]
  end

  # 🔍 必要なら関連の検索許可も追加（今回は不要かも）
  def self.ransackable_associations(auth_object = nil)
    []
  end

    # 登録完了後に welcome メール送信
  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
