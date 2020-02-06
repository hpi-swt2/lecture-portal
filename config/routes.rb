Rails.application.routes.draw do
  get "/courses/:course_id/lectures/current", to: "lectures#current", as: "current_lectures"
  get "/courses/available", to: "courses#available", as: "available_courses"
  get "/courses/:course_id/lectures/:lecture_id/studentList", to: "lectures#studentList", as: "studentList"
  get "/ical/:hash_id", to: "ical#show", as: "ical"
  post "/courses/:course_id/lectures/join_lecture", to: "lectures#join_lecture", as: "join_lecture"
  get "/courses/:course_id/lectures/:lecture_id/enroll", to: "lectures#join_lecture_with_url", as: "join_lecture_with_url"
  post "/courses/:course_id/lectures/leave_lecture", to: "lectures#leave_lecture", as: "leave_lecture"
  post "/courses/join_course", to: "courses#join_course", as: "join_course"
  post "/courses/leave_course", to: "courses#leave_course", as: "leave_course"

  resources :courses do
    resources :uploaded_files, only: [:show, :index, :new, :create, :destroy]
    resources :lectures do
      resources :polls do
        member do
          patch :save_answers
          post :save_answers
          get :stop_start
          get :serialized_options
          get :serialized_participants_count
          get :answer
        end
      end
      resources :uploaded_files # , only: [:show, :index, :new, :create, :destroy]
      resources :feedbacks

      get "comprehension", to: "lectures#get_comprehension", on: :member
      put "comprehension", to: "lectures#update_comprehension_stamp", on: :member

      resources :questions, only: [:index, :create] do
        post "upvote", on: :member
        post "resolve", on: :member
      end
    end
  end

  devise_for :users, controllers: {
      confirmations: "users/confirmations",
      passwords: "users/passwords",
      registrations: "users/registrations",
      sessions: "users/sessions",
      unlocks: "users/unlocks",
  }

  devise_scope :user do
    get "/users/show" => "users/registrations#show"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  mount ActionCable.server => "/cable"
end
