class Tag < ApplicationRecord
  # 関連付けの追加
  has_many :knowhow_tags, dependent: :destroy
  has_many :knowhows, through: :knowhow_tags

  # Ransackでの検索を許可するカラムを指定
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end
end
