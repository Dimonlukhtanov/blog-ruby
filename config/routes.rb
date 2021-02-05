Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  get 'myposts' => 'posts#myposts'
  get 'mydrafts' => 'posts#mydrafts'
  resources :posts do
    get '/up_rate/' => 'posts#up_rate_post'
    get '/down_rate/' => 'posts#down_rate_post'
    resources :comments
  end
end
