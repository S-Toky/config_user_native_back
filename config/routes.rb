Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/profil',  to:'users#edit', as: :profil
  patch '/profil', to: 'users#update'
  resources :passwords, only: [:new, :create, :edit, :update]
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

end
