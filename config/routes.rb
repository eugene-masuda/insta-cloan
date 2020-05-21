Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
 get 'sessions/new'
 get 'users/new'
 root 'static_pages#home'
 get  'static_pages/home'
 get  '/signup',  to: 'users#new'
 post '/signup',  to: 'users#create'
 get    '/login',   to: 'sessions#new'
 post   '/login',   to: 'sessions#create'
 delete '/logout',  to: 'sessions#destroy'
 resources :users
 resources :password_resets,     only: [:new, :create, :edit, :update]
end
