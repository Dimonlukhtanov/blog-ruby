Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  get 'myposts' => 'posts#myposts'
  get 'mydrafts' => 'posts#mydrafts'
  get '/users/' => 'users#index', as: 'users'
  get '/ban/:id' => 'users#ban', as: 'ban'
  get '/unban/:id' => 'users#unban', as: 'unban'
  resources :posts do
    get '/up_rate/' => 'posts#up_rate_post'
    get '/down_rate/' => 'posts#down_rate_post'
    resources :comments
  end
end
