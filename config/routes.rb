Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      # 1) api/v1/users -------------------> View all users in organization, create new users [Every http method]
      # 2) api/v1/timelogs -----------------> View all timelogs as organization owner. [Every http method, except create as it needs a project and a user.]
      # 3) api/v1/projects -----------------> View all projects as organization owner. [Every http method except create as it needs user id]
      # 4) api/v1/users/:user_id/projects -------------> User views his projects, create a project as organization manager [Index, Create, Destroy, Update]
      # 5) api/v1/projects/:project_id/timelogs ---------> Project owner sees everybody's timelogs from a project [Index]
      # 6) api/v1/users/:user_id/projects/:project_id/timelogs ---------------> See timelogs from a user in a project, user creates a timelog (maybe temporary) [Index, Update, Create, Destroy]

      resources :users #1

      # [START login]
      get "/login", to: redirect("/auth/google_oauth2")
      # [END login]

      # [START sessions]
      get "/auth/google_oauth2/callback", to: "sessions#create"

      resource :session, only: [:create, :destroy]
      # [END sessions]

      # [START logout]
      get "/logout", to: "sessions#destroy"
      # [END logout]

      resources :timelogs, except: [:create, :delete, :update] #2
      resources :projects, except: [:create, :delete, :update] #3

      resources :users, only: [] do
        resources :projects, only: [:index, :create, :destroy, :update] #4
      end

      resources :projects, only: [] do
        resources :timelogs, only: [:index] #5
      end

      resources :users, only: [] do
        resources :projects, only: [] do
          resources :timelogs, except: [:show] #6
        end
      end

    end
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
