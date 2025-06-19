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
  has_many :purchases, dependent: :destroy
  has_many :chat_rooms, dependent: :destroy

  # Active Storage (ファイルアップロード)
  has_many_attached :media_files

  # タグ機能 (多対多)
  has_many :knowhow_tags, dependent: :destroy
  has_many :tags, through: :knowhow_tags

  # --- 仮想属性 (Virtual Attributes) ---
  # フォームからタグ名の文字列を受け取るため
  attr_accessor :tag_list

  # --- バリデーション (Validations) ---
  # validates :title, presence: true # 例: タイトルは必須

  # --- コールバック (Callbacks) ---
  # データ保存後に、タグを保存・関連付けする処理を呼び出す
  after_save :save_tags

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
    tag_names = self.tag_list.split(',').map(&:strip).uniq
    
    # 各タグ名について、DBに存在すればそれを使い、なければ新規作成
    new_tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }
    
    # この投稿(Knowhow)に、見つけてきた、あるいは新規作成したタグを関連付ける
    self.tags = new_tags
  end
end
