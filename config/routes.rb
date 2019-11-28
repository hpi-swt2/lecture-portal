Rails.application.routes.draw do
  resources :feedbacks
  resources :polls
  resources :lectures
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
