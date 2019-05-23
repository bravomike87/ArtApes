Rails.application.routes.draw do

  devise_for :users

  # get 'bookings/new'
  root to: 'pages#home'
  get 'profiles/:id/artworks', to: 'profiles#artworks'
  get 'profiles/:id/requests', to: 'profiles#requests'

  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :artworks do
    resources :bookings, only: [:new, :create, :index]
  end
  resources :bookings, only: [:destroy]

  resources :profiles, except: [:index]

end
