Rails.application.routes.draw do
  get 'messages/new'

  get 'password_resets/new'

  get 'password_resets/edit'

  root   'staticpages#home'
  get    '/help',    to: 'staticpages#help'
  get    '/about',   to: 'staticpages#about'
  get    '/contact', to: 'staticpages#contact'
#  get    '/signup',  to: 'users#new'
  get    '/signup_1',  to: 'people#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post    '/signup_1',  to: 'people#create'
   get 'microposts/index', to: 'microposts#index'
   get 'page/:id' => 'microposts#page', :as => 'page'
     get  'people/ranking'

     mount ActionCable.server => '/cable'

  resources :people do
    member do
      get :requestlist, :receivelist
    end
  end

  resources :microposts do
    resources :comments, :only => [:create, :destroy]
  end

#  resources :users
  resources :people
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy, :update]
  resources :relationships,       only: [:create, :destroy, :update]
end
