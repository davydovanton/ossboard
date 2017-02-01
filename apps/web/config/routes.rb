root to: 'main#index'

get '/leaderboards', to: 'leaderboards#index'

get '/about',        to: 'static#about', as: 'about'
get '/how-to-help',  to: 'static#help',  as: 'help'

resources :users,       only: %i[show]
resources :task_status, only: %i[update]
resources :tasks,       only: %i[index new create show edit update]
