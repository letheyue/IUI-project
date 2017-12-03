Rails.application.routes.draw do

  get 'sessions/new'

  get 'users/new'

  get 'restaurants/show'

  root 'static_pages#home'

  get 'static_pages/contact'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  resources :users do
    resources :preferences, except: [:edit, :destroy] do
      collection do
        post 'destroy_all'
      end
    end
    post 'feedback', to: 'feedbacks#save'

  end

  # get '/search', to: 'restaurants#search'

  resources :users

  resources :restaurants do
    collection do
      get :search
      get :aggregated
      get :search_aggregated
    end
  end

  resources :restaurants do
    resources :reviews, only: [:new] do

    end
  end
  post '/restaurants/:restaurant_id/reviews/new', to: 'reviews#create'


  resources :sessions, only: [:create, :destroy]
  # facebook login & google login
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')


end
