Rails.application.routes.draw do
  get "home/index"

  # devise_for :users

  resources :knowhows do
    resources :purchases, only: [:new, :create]
    resources :chat_rooms, only: [:show]
  end

  resources :users, only: [:show]

  # チャット用に直接チャットルームやメッセージを設けてもよい
  # resources :chat_rooms, only: [:index, :show] do
  #   resources :chat_messages, only: [:create]
  # end
end
