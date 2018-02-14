Rails.application.routes.draw do
  post '/oauth2/google', to: "authentications#create"
  delete '/oauth2/google', to: "authentications#destroy"

  namespace 'api' do
    namespace 'v1' do
      
      get "/user/projects", to: "projects#show_current_user_projects"
      get "/user/projects/:project_id/timelogs", to: "timelogs#show_current_user_timelogs"
      post "/projects/:project_id/timelogs", to: "timelogs#create"
      get "/projects/:project_id/timelogs", to: "timelogs#show_project_timelogs"
      get "/timelogs/pending", to: "timelogs#pending"
      
      resources :users #1
      resources :timelogs #2
      resources :projects #3
    end
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
