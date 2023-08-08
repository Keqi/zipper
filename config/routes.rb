Rails.application.routes.draw do
  resources :users, only: :create
  resources :files, only: [:create, :index]

  post 'sign_in', to: 'sessions#create'
end
