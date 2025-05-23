Rails.application.routes.draw do
  # トップページ
  root 'home#index'

  # Devise 認証
  devise_for :users

  # ユーザーマイページ関連（単数リソース）
  resource :user, only: [:show, :edit, :update]

  # ノウハウ関連
  resources :knowhows do
    resources :purchases, only: [:new, :create]
    resources :chat_rooms, only: [:show]
  end

  # グローバルチャット（複数のチャットルーム想定）
  resources :chat_rooms, only: [:index, :show] do
    resources :chat_messages, only: [:create]
  end
end
