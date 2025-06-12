class Knowhow < ApplicationRecord
  belongs_to :user
  has_many_attached :media_files
  has_many :purchases, dependent: :destroy
  has_one :chat_room, dependent: :destroy

  # 属性名を category_type に変更
  enum :category_type, {
    document: 0,
    video: 1,
    image: 2,
    audio: 3
  }

  # 🔍 Ransackで検索可能なカラムを明示
  def self.ransackable_attributes(auth_object = nil)
    # "category" を検索可能な属性のリストに追加します
    %w[title description price created_at updated_at user_id category_type]
  end

  # 🔍 Ransackで関連付けの検索を許可（user.name など）
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
