Rails.application.routes.draw do
  resources :users, only: :create

  post 'sign_in', to: 'sessions#create'
  post 'sign_out', to: 'sessions#destroy'
end
