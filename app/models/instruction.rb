class Instruction < ApplicationRecord
  belongs_to :knowhow
  has_one_attached :image

  validates :description, presence: true
  validate :image_presence

  private

  def image_presence
    errors.add(:image, "画像をアップロードしてください") unless image.attached?
  end
end
