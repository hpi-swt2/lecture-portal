Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :questions
  get '/api/questions', to: 'questions_api#index'
  post '/api/questions', to: 'questions_api#create'

  mount ActionCable.server => '/cable'
end
