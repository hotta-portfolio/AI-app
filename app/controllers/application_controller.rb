class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_global_ransack

  protected

  # Deviseのストロングパラメータ拡張
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :profile, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :profile, :avatar ])
  end

  private

  # 全コントローラ共通で@q（Ransack検索オブジェクト）を利用可能にする
  def set_global_ransack
    @q = Knowhow.ransack(params[:q])
  end
end
