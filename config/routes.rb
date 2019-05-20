Rails.application.routes.draw do
  get 'artworks/index'
  get 'artworks/show'
  get 'artworks/new'
  get 'artworks/edit'
  get 'profiles/show'
  get 'profiles/new'
  get 'profiles/edit'
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
