Rails.application.routes.draw do
  # トップページ
  root "home#index"

  # Devise 認証
  devise_for :users

  # ユーザーマイページ関連（単数リソース）
  resource :user, only: [ :show, :edit, :update ]

  # ノウハウ関連
  resources :knowhows do
    # 購入関連
    resources :purchases, only: [ :new, :create ] do
      # app/javascript/stripe_payment.jsの73行目で作ったURLで、Railsが決済完了を確認し、confirmアクションが発火するので、必要となる
      post :confirm, on: :collection
    end

    # チャット関連
    resources :chat_rooms, only: [ :show ]

    # メディア削除用
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
