# app/controllers/knowhows_controller.rb
class KnowhowsController < ApplicationController
  # ログインしていないユーザーは、新規作成や編集はできないようにする
  before_action :authenticate_user!, except: [:index, :show]
  
  # show/edit/update/destroyで共通して使うノウハウ取得処理をまとめる
  before_action :set_knowhow, only: [:show, :edit, :update, :destroy]

  # ノウハウ一覧ページ
  def index
    # N+1問題を避けるために関連テーブルも読み込む
    @knowhows = Knowhow.includes(:user, media_files_attachments: :blob).order(created_at: :desc)
    
    # 後で検索や並び替え機能をここに追加予定
  end

  # ノウハウ詳細ページ
  def show
    # 現在のユーザーがこのノウハウを購入済みかどうかを判定
    @purchased = current_user&.purchases&.exists?(knowhow_id: @knowhow.id)
  end

  # 新規投稿フォーム表示
  def new
    # 現在ログイン中のユーザーに紐付く新規Knowhowインスタンスを作成
    @knowhow = current_user.knowhows.new
  end

  # 新規投稿処理
  def create
    @knowhow = current_user.knowhows.new(knowhow_params)

    if @knowhow.save
      # 保存成功したら詳細ページへリダイレクトし、メッセージを表示
      redirect_to @knowhow, notice: "ノウハウを投稿しました"
    else
      # 保存失敗なら投稿フォームを再表示してエラーメッセージを表示
      render :new
    end
  end

  # 編集フォーム表示
  def edit
    # @knowhowはbefore_actionで取得済み
    # 投稿者本人しか編集できないように制限するのが望ましい
    unless @knowhow.user == current_user
      redirect_to knowhows_path, alert: "編集権限がありません"
    end
  end

  # 更新処理
  def update
    if @knowhow.user != current_user
      redirect_to knowhows_path, alert: "編集権限がありません"
      return
    end

    if @knowhow.update(knowhow_params)
      redirect_to @knowhow, notice: "ノウハウを更新しました"
    else
      render :edit
    end
  end

  # 削除処理
  def destroy
    if @knowhow.user == current_user
      @knowhow.destroy
      redirect_to knowhows_path, notice: "ノウハウを削除しました"
    else
      redirect_to knowhows_path, alert: "削除権限がありません"
    end
  end

  private

  # ストロングパラメータ（フォームから受け取る安全な値だけを許可）
  def knowhow_params
    # media_filesは複数アップロードできるので配列で許可
    params.require(:knowhow).permit(:title, :description, :price, media_files: [], tag_ids: [])
  end

  # 共通で使うノウハウ取得メソッド
  def set_knowhow
    @knowhow = Knowhow.find(params[:id])
  end
end
