Rails.application.routes.draw do
  resources :users, only: :create

  post 'upload', to: 'files#create'

  post 'sign_in', to: 'sessions#create'
end
