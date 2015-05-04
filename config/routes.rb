Rails.application.routes.draw do
  root 'pages#home'
  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create, :show]

  resources :reservations


  resources :restaurants do
    resources :reservations
  end


end
