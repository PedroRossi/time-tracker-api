Rails.application.routes.draw do
  get 'sessions/index'

  # [START login]
  get "/login", to: redirect("auth/google_oauth2")
  # [END login]

  # [START sessions]
  get "/auth/google_oauth2/callback", to: "sessions#create"

  resources :session, only: [:create, :destroy]
  # [END sessions]

  # [START logout]
  get "/logout", to: "sessions#destroy"
  # [END logout]

  namespace 'api' do
    namespace 'v1' do
      resources :users #1
      get "/timelogs/pending", to: "timelogs#pending"
      resources :timelogs #2
      resources :projects #3
      resources :users
    end
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
