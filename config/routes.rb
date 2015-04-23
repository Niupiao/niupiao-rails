Rails.application.routes.draw do

  get 'managers/new'

  get 'static_pages/home'
  get 'static_pages/about'

  root 'static_pages#home'

  get 'login',     to: 'sessions#new'
  post 'login',    to: 'sessions#create'
  post 'facebooklogin', to: 'facebook#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'sessions#signup_page'
  post 'signup', to: 'sessions#signup'
  
  get 'events', to: 'events#index'

  get 'me/tickets', to: 'tickets#my_tickets'

  post '/buy', to: 'tickets#batch_buy'
  post '/events/:event_id/tickets/:ticket_id/buy', to: 'tickets#buy'
  resources :events do
    resources :tickets, shallow: true
  end
  

end
