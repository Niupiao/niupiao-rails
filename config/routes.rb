Rails.application.routes.draw do

  root 'sessions#new'

  get 'login',     to: 'sessions#new'
  post 'login',    to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'sessions#signup_page'
  post 'signup', to: 'sessions#signup'

  get 'me/tickets', to: 'tickets#my_tickets'
  
  resources :events do
    resources :tickets, shallow: true
  end

end
