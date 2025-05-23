Rails.application.routes.draw do
  get "chat_rooms/show"
  get "home/index"

  devise_for :users

  resources :knowhows do
    resources :purchases, only: [:new, :create]
    resources :chat_rooms, only: [:show]
  end

  # チャット用に直接チャットルームやメッセージを設けてもよい
  resources :chat_rooms, only: [:index, :show] do
    resources :chat_messages, only: [:create]
  end
end
