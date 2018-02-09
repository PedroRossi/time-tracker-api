Rails.application.routes.draw do
  post '/oauth2/google', to: "authentication#create"
  delete '/oauth2/google', to: "authentication#destroy"

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
