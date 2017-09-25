root to: 'main#index'

get '/about',        to: 'static#about', as: 'about'
get '/how-to-help',  to: 'static#help',  as: 'help'

resources :users, only: %i[show] do
  member do
    get 'settings'
  end
end

resources :task_status, only: %i[update]
resources :tasks,       only: %i[index new create show edit update]
