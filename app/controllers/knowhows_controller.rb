class KnowhowsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_knowhow, only: [ :show, :edit, :update, :destroy, :delete_media, :instructions ]

  def index
    @q = Knowhow.ransack(params[:q])
    @knowhows = @q.result(distinct: true)
                  .includes(:user, :tags, media_files_attachments: :blob)
                  .order(created_at: :desc)
  end

  def show
    @purchase = current_user&.purchases&.find_by(knowhow_id: @knowhow.id)
    @purchased = @purchase.present?
  end

  def new
    @knowhow = current_user.knowhows.new
    @knowhow.instructions.build(step: 1) if @knowhow.instructions.empty?
  end

  def create
    @knowhow = current_user.knowhows.new(knowhow_params)
    if @knowhow.save
      redirect_to @knowhow, notice: "ノウハウを投稿しました"
    else
      render :new
    end
  end

  def edit
    unless @knowhow.user == current_user
      redirect_to knowhows_path, alert: "編集権限がありません"
      return
    end

    # instructions が空なら最低1個 build
    @knowhow.instructions.build if @knowhow.instructions.empty?
  end

  def update
    if @knowhow.user != current_user
      redirect_to knowhows_path, alert: "編集権限がありません"
      return
    end

    # --- 🔽 ActiveStorage 用の特別処理 ---
    existing_ids = params[:knowhow][:existing_media_file_ids] || []
    new_files    = params[:knowhow][:media_files] || []

    # 既存ファイルのうち、hidden_field に含まれないものは削除
    @knowhow.media_files.each do |file|
      file.purge unless existing_ids.include?(file.id.to_s)
    end

    # 新規ファイルを追加
    new_files.each do |file|
      @knowhow.media_files.attach(file)
    end

    # 他の属性を更新
    if @knowhow.update(knowhow_params.except(:media_files, :existing_media_file_ids))
      redirect_to @knowhow, notice: "ノウハウを更新しました"
    else
      render :edit
    end
  end

  def instructions
    @purchase = current_user&.purchases&.find_by(knowhow_id: @knowhow.id)
    unless @purchase && @purchase.knowhow.chat_room.present?
      redirect_to @knowhow, alert: "生成手順を閲覧する権限がありません"
      return
    end
    @instructions = @knowhow.instructions.order(:step)
    @softwares = @instructions.pluck(:software).reject(&:blank?)
  end

  def destroy
    if @knowhow.user == current_user
      @knowhow.destroy
      redirect_to knowhows_path, notice: "ノウハウを削除しました"
    else
      redirect_to knowhows_path, alert: "削除権限がありません"
    end
  end

  def delete_media
    authorize_user!
    file = @knowhow.media_files.find(params[:file_id])
    file.purge_later
    redirect_to edit_knowhow_path(@knowhow), notice: "ファイルを削除しました"
  end

  private

  def knowhow_params
    params.require(:knowhow).permit(
      :title,
      :description,
      :price,
      :category_type,
      :tag_list,
      :thumbnail,
      :software,
      media_files: [],
      existing_media_file_ids: [],
      tag_ids: [],
      instructions_attributes: [ :id, :step, :description, :image, :_destroy ],
    )
  end

  def set_knowhow
    @knowhow = Knowhow.find(params[:id])
  end
  def authorize_user!
    redirect_to knowhows_path, alert: "編集権限がありません" unless @knowhow.user == current_user
  end
end
