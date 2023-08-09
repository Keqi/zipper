Rails.application.routes.draw do
  resources :users, only: :create
  resources :files, only: [:create, :index]
  resources :tokens, only: :create
end
