class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 200 }

  has_one_attached :avatar
  has_many :knowhows, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :chat_rooms, through: :knowhows
  has_many :messages, dependent: :destroy
  has_one_attached :avatar

  def display_avatar
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        avatar.variant(resize_to_fill: [ 40, 40 ]).processed,
        only_path: true
      )
    else
      "/default_avatar.png" # デフォルト画像を public に置いておく
    end
  end


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
