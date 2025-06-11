# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  # ユーザー認証が必要なアクションを指定（例: ログインしている場合のみ投稿可能など）
  # before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    # Ransackの検索オブジェクトを生成
    # params[:q] には検索フォームから送られてきた検索条件が入ります
    @q = Post.ransack(params[:q])

    # 検索結果を取得
    # @q.result で検索結果のActiveRecord::Relationオブジェクトを取得できます
    # distinct: true は、検索結果に重複がある場合（例: 関連テーブルを結合した検索）に重複を排除します
    @posts = @q.result(distinct: true)

    # Note: 投稿機能の他のアクションもここに実装されますが、
    # 検索機能は主にindexアクションに組み込みます。
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url, notice: '投稿が削除されました。'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body) # 許可するカラムを指定
  end
end
