Rails.application.routes.draw do
  # トップページ
  root "home#index"

  # Devise 認証
  devise_for :users

  # ユーザーマイページ関連（単数リソース）
  resource :user, only: [ :show, :edit, :update ]

  # ノウハウ関連
  resources :knowhows do
    patch :update_step1, on: :member
    post  :create_step1, on: :collection  # 新規作成用STEP1保存

    resources :purchases, only: [ :new, :create ] do
      post :confirm, on: :collection
    end

    resources :chat_rooms, only: [ :show ]

    member do
      delete :delete_media
    end

    get :instructions, on: :member
  end


  # グローバルチャット（複数のチャットルーム想定）
  resources :chat_rooms, only: [ :index, :show ] do
    resources :messages, only: [ :create ]
  end

  # マイページ系まとめ
  resources :purchases, only: :index   # 購入履歴
  resource :payment, only: [ :show, :edit, :update ]
end
