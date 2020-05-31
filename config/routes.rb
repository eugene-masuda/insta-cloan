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
 resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users do
  member do
    get :following, :followers , :likes
  end
end
 resources :users
 resources :password_resets,     only: [:new, :create, :edit, :update]
 resources :microposts, only: [:show, :new, :create, :destroy]
 delete '/login', to: 'users#destroy'
 resources :relationships,       only: [:create, :destroy]
 post   "likes/:micropost_id/create"  => "likes#create"
 delete "likes/:micropost_id/destroy" => "likes#destroy"
 resources :comments, only: [:create, :destroy]
 post "/microposts/:id", to: "comments#create"
 resources :notifications, only: [:index]
 resources :favorite_relationships, only: [:create, :destroy]

end
