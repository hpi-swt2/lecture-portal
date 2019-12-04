Rails.application.routes.draw do
  get "/lectures/current", to: "lectures#current", as: "current_lectures"
  resources :lectures do
    resources :polls
  end

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
end
