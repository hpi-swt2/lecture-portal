Rails.application.routes.draw do
  get "/lectures/current", to: "lectures#current", as: "current_lectures"
  resources :lectures
  devise_for :users
  resources :polls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
