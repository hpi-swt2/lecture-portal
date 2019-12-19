Rails.application.routes.draw do
  resources :courses
  get "/lectures/current", to: "lectures#current", as: "current_lectures"
  post "/lectures/start_lecture", to: "lectures#start_lecture", as: "start_lecture"
  post "/lectures/join_lecture", to: "lectures#join_lecture", as: "join_lecture"
  post "/courses/join_course", to: "courses#join_course", as: "join_course"
  post "/lectures/end_lecture", to: "lectures#end_lecture", as: "end_lecture"

  resources :lectures do
    resources :polls
    resources :feedbacks
  end

  resources :questions, only: [:index]
  namespace :api do
    resources :questions, only: [:index, :create] do
      post "resolve", on: :member
    end
  end

  devise_for :users, controllers: {
      confirmations: "users/confirmations",
      passwords: "users/passwords",
      registrations: "users/registrations",
      sessions: "users/sessions",
      unlocks: "users/unlocks",
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  mount ActionCable.server => "/cable"
end
