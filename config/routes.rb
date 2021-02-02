Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  get 'myposts' => 'posts#myposts'
  get 'mydrafts' => 'posts#mydrafts'
  resources :posts do
    resources :comments
  end
end
