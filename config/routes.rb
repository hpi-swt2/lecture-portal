Rails.application.routes.draw do
  resources :questions
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  get '/api/questions', to: 'questions#apiIndex'
  post '/api/questions', to: 'questions#apiCreate'
  mount ActionCable.server => '/cable'

end
