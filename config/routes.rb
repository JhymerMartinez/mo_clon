Moi::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "api/registrations" }

  namespace :api, defaults: { format: :json } do
    resource :tree, only: :show
    resource :learn, controller: :learn, only: :create
    resources :search, only: :index
    resources :content_preferences, only: :update
    resource :order_preferences, controller: :order, only: :update
    resources :neurons,
              only: [:index, :show] do
      resources :recommended_contents,
                only: :show
      resources :contents,
                only: [:show] do
        member do
          post :read
          post :notes
          post :media_open
          post :tasks
          post :task_update
        end
      end
    end

    resources :analytics,
                only: [:statistics] do
      collection do
        get :statistics
      end
    end

    namespace :users do
      resource :account,
                only: [:update]
      resource :tree_image,
                only: [:update]
      resource :recommended_neurons,
                only: [:show]
    end

    match "users/search" => 'users#search', via: :get
    match "users/content_tasks" => 'users#content_tasks', via: :get
    match "users/content_notes" => 'users#content_notes', via: :get
    resources :users,
              only: [] do
      member do
        get :profile
      end
    end

    namespace :auth do
      mount_devise_token_auth_for(
        "User",
        at: "user",
        controllers: {
          sessions: "api/sessions",
          token_validations: "api/token_validations",
          registrations: "api/registrations"
        }
      )
    end
  end

  namespace :admin do
    resource :dashboard, only: :index
    resources :users
    resources :profiles

    # settings
    resources :settings, only: :index
    resources :search_engines, except: [:index, :destroy]

    # preview
    match "neurons/preview" => "neurons/preview#preview",
          via: [:post, :patch],
          as: :neuron_preview

    resources :neurons do
      resource :log, module: "neurons",
                     only: :show
      member do
        post :delete
        post :restore
      end
      collection do
        get :sort
        get :sorting_tree
        post :reorder
      end
    end

    resource :external_search, only: :create

    resources :contents do
      member do
        post :approve
      end
    end

    root "dashboard#index"
  end

  namespace :tutor do
    resources :moi, only: :index
    resources :client, only: [:index, :show]
    resources :analysis, only: [:index, :show]
    resources :tree, only: :index

    root "moi#index"
  end

  match "/delayed_job" => DelayedJobWeb,
        anchor: false,
        via: [:get, :post]

  root to: redirect("/apipie")
  apipie
end
