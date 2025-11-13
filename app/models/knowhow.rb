class Knowhow < ApplicationRecord
  # --- 定数・Enum ---
  enum :category_type, {
    document: 0,
    video: 1,
    image: 2,
    audio: 3
  }

  # --- 関連付け ---
  belongs_to :user
  has_one_attached :thumbnail
  has_many :purchases, dependent: :destroy
  has_one :chat_room, dependent: :destroy   # ← OK（存在する時だけ）
  has_many :instructions, -> { order(:step) }, dependent: :destroy
  accepts_nested_attributes_for :instructions, allow_destroy: true
  has_many_attached :media_files

  has_many :knowhow_tags, dependent: :destroy
  has_many :tags, through: :knowhow_tags

  attr_accessor :tag_list
  attr_accessor :step2_submitted

  after_save :save_tags

  validates :title, presence: true
  validates :description, presence: true
  validates :category_type, presence: true
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 100 }

  validates :software, presence: true, if: :step2_submitted?

  validates_associated :instructions

  def self.ransackable_attributes(auth_object = nil)
    %w[title description price created_at updated_at user_id category_type]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user tags]
  end

  def step2_submitted?
    step2_submitted == true
  end

  private

  def save_tags
    return unless self.tag_list.present?
    self.tags.clear
    tag_names = self.tag_list.split(",").map(&:strip).uniq
    new_tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }
    self.tags = new_tags
  end
end
