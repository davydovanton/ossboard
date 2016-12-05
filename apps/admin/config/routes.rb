get '/users', to: 'users#index'
resources :moderation, only: %i[index update]
resources :tasks, only: %i[index show edit update]

root to: 'dashboard#index'
