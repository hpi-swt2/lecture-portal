Rails.application.routes.draw do
  resources :questions, only: [:index]
  namespace :api do
    resources :questions, only: [:index, :create]
  end
  resources :polls
  resources :lectures
  devise_for :users, controllers: {
      confirmations: "users/confirmations",
      passwords: "users/passwords",
      registrations: "users/registrations",
      sessions: "users/sessions",
      unlocks: "users/unlocks",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  
  mount ActionCable.server => '/cable'
end
