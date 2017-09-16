Rails.application.routes.draw do
  get 'users/new'

  root 'static_pages#home'

  get 'static_pages/contact'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'

end
