Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api/docs'
  mount Rswag::Api::Engine => '/api/docs'

  resources :users, only: :create
  resources :files, only: [:create, :index]
  resources :tokens, only: :create
end
