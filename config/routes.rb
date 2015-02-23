Rails.application.routes.draw do

  root 'sessions#login_page'

  get 'login', to: 'sessions#login_page'
  post 'login', to: 'sessions#login'
  get 'logout', to: 'sessions#logout'

  get 'signup', to: 'sessions#signup_page'
  post 'signup', to: 'sessions#signup'

  get 'me/tickets', to: 'tickets#my_tickets'
  
  resources :events do
    resources :tickets, shallow: true
  end

end
