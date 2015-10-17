Rails.application.routes.draw do

  devise_for :users#, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }

  # devise_scope :user do
  #   get "users/sign_in" => '/', via: :get
  #   get "users/sign_up" => '/', via: :get
  # end

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :daycares do
    collection do
      match :login, via: [:get, :post]
    end
    member do
      match :add_departments, via: [:get, :post]
      get :congratulations
      match :invite_parents, via: [:get, :post]
      match :invite_workers, via: [:get, :post]
    end
  end
  
  resources :todos do
    member do
      get :share_todo
      match :todo_departments, via: [:get, :post]
      post :accept_todo
    end
    collection do
      get :search
    end
  end

  # Example resource route within a namespace:
  namespace :admin do
    match :login, to: 'admin#login', via: [:get, :post]
    get :dashboard, to: 'admin#dashboard'
    get :select_privilege, to: 'admin#select_privilege'
    match :set_privilege, to: 'admin#set_privilege', via: [:get, :post]
    get :functionality, to: 'admin#functionality'
    get :fetch_customer_types, to: 'admin#fetch_customer_types'
    get :fetch_customers, to: 'admin#fetch_customers'
    resources :customers, only: [] do
      collection { 
        get  :import_new
        post :import
        match :add_customer_types, via: [:get, :post]
      }
      member do
        match :notify_users, via: [:get, :post]
      end
    end
    resources :todos do
      collection do
        get :todos
        get :todo_assignee
        get :search
        # get :fetch_customer_types
      end
    end
  end
end
