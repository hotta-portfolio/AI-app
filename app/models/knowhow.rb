class Knowhow < ApplicationRecord
  # --- 定数・Enum ---
  enum :category_type, {
    document: 0,
    video: 1,
    image: 2,
    audio: 3
  }

  # --- 関連付け (Associations) ---
  belongs_to :user
  has_one_attached :thumbnail
  has_many :purchases, dependent: :destroy
  has_one :chat_room, dependent: :destroy
  has_many :instructions, -> { order(:step) }, dependent: :destroy
  accepts_nested_attributes_for :instructions, allow_destroy: true
  has_many_attached :media_files

  # タグ機能 (多対多)
  has_many :knowhow_tags, dependent: :destroy
  has_many :tags, through: :knowhow_tags

  # --- 仮想属性 (Virtual Attributes) ---
  # フォームからタグ名の文字列を受け取るため
  attr_accessor :tag_list

  # --- コールバック (Callbacks) ---
  # データ保存後に、タグを保存・関連付けする処理を呼び出す
  after_save :save_tags
  after_create :create_chat_room!


  validates :title, :description, :category_type, :price, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100 }
  validate :validate_instructions_presence
  validate :must_have_at_least_one_media

  def must_have_at_least_one_media
    # 既存アタッチメント + 新規アップロード分の合計が0ならエラー
    total_files_count = media_files_attachments.size + Array(media_files).size
  
    if total_files_count.zero?
      errors.add(:media_files, "は最低1つ必要です")
    end
  end
  

  # --- クラスメソッド (Class Methods) ---
  # Ransackで検索可能な「属性」を明示
  def self.ransackable_attributes(auth_object = nil)
    %w[title description price created_at updated_at user_id category_type]
  end

  # Ransackで検索可能な「関連」を明示
  def self.ransackable_associations(auth_object = nil)
    # タグ検索のために "tags" を追加
    %w[user tags]
  end

  # --- インスタンスメソッド (Instance Methods) ---
  # (必要に応じてここに追加)

  private

  # `tag_list`の文字列を解析して、タグを保存・関連付けするメソッド
  def save_tags
    return unless self.tag_list.present?

    # 現在のタグとの関連を一旦全て削除（更新時のため）
    self.tags.clear

    # 受け取った文字列をカンマで分割し、前後の空白を削除し、重複を除外
    tag_names = self.tag_list.split(",").map(&:strip).uniq

    # 各タグ名について、DBに存在すればそれを使い、なければ新規作成
    new_tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }

    # この投稿(Knowhow)に、見つけてきた、あるいは新規作成したタグを関連付ける
    self.tags = new_tags
  end

  def validate_instructions_presence
    if instructions.empty? || instructions.all? { |i| i.description.blank? && i.image.blank? }
      errors.add(:instructions, "少なくとも1つの手順を入力してください")
    end

    # 各 instruction の個別チェック
    instructions.each_with_index do |instruction, idx|
      if instruction.description.blank? && instruction.image.blank?
        errors.add(:instructions, "STEP#{idx + 1}の説明または画像を入力してください")
      end
    end
  end
end
