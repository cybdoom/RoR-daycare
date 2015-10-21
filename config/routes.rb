# == Route Map
#
#                             Prefix Verb     URI Pattern                                   Controller#Action
#                   new_user_session GET      /users/sign_in(.:format)                      devise/sessions#new
#                       user_session POST     /users/sign_in(.:format)                      devise/sessions#create
#               destroy_user_session DELETE   /users/sign_out(.:format)                     devise/sessions#destroy
#                      user_password POST     /users/password(.:format)                     devise/passwords#create
#                  new_user_password GET      /users/password/new(.:format)                 devise/passwords#new
#                 edit_user_password GET      /users/password/edit(.:format)                devise/passwords#edit
#                                    PATCH    /users/password(.:format)                     devise/passwords#update
#                                    PUT      /users/password(.:format)                     devise/passwords#update
#           cancel_user_registration GET      /users/cancel(.:format)                       devise/registrations#cancel
#                  user_registration POST     /users(.:format)                              devise/registrations#create
#              new_user_registration GET      /users/sign_up(.:format)                      devise/registrations#new
#             edit_user_registration GET      /users/edit(.:format)                         devise/registrations#edit
#                                    PATCH    /users(.:format)                              devise/registrations#update
#                                    PUT      /users(.:format)                              devise/registrations#update
#                                    DELETE   /users(.:format)                              devise/registrations#destroy
#                               root GET      /                                             welcome#index
#                     login_daycares GET|POST /daycares/login(.:format)                     daycares#login
#            add_departments_daycare GET|POST /daycares/:id/add_departments(.:format)       daycares#add_departments
#            congratulations_daycare GET      /daycares/:id/congratulations(.:format)       daycares#congratulations
#             invite_parents_daycare GET|POST /daycares/:id/invite_parents(.:format)        daycares#invite_parents
#             invite_workers_daycare GET|POST /daycares/:id/invite_workers(.:format)        daycares#invite_workers
#                           daycares GET      /daycares(.:format)                           daycares#index
#                                    POST     /daycares(.:format)                           daycares#create
#                        new_daycare GET      /daycares/new(.:format)                       daycares#new
#                       edit_daycare GET      /daycares/:id/edit(.:format)                  daycares#edit
#                            daycare GET      /daycares/:id(.:format)                       daycares#show
#                                    PATCH    /daycares/:id(.:format)                       daycares#update
#                                    PUT      /daycares/:id(.:format)                       daycares#update
#                                    DELETE   /daycares/:id(.:format)                       daycares#destroy
#              login_daycare_workers GET|POST /daycare_workers/login(.:format)              daycare_workers#login
#           dashboard_daycare_worker GET      /daycare_workers/:id/dashboard(.:format)      daycare_workers#dashboard
#                    daycare_workers GET      /daycare_workers(.:format)                    daycare_workers#index
#                                    POST     /daycare_workers(.:format)                    daycare_workers#create
#                 new_daycare_worker GET      /daycare_workers/new(.:format)                daycare_workers#new
#                edit_daycare_worker GET      /daycare_workers/:id/edit(.:format)           daycare_workers#edit
#                     daycare_worker GET      /daycare_workers/:id(.:format)                daycare_workers#show
#                                    PATCH    /daycare_workers/:id(.:format)                daycare_workers#update
#                                    PUT      /daycare_workers/:id(.:format)                daycare_workers#update
#                                    DELETE   /daycare_workers/:id(.:format)                daycare_workers#destroy
#              login_daycare_parents GET|POST /daycare_parents/login(.:format)              daycare_parents#login
#           dashboard_daycare_parent GET      /daycare_parents/:id/dashboard(.:format)      daycare_parents#dashboard
#                    daycare_parents GET      /daycare_parents(.:format)                    daycare_parents#index
#                                    POST     /daycare_parents(.:format)                    daycare_parents#create
#                 new_daycare_parent GET      /daycare_parents/new(.:format)                daycare_parents#new
#                edit_daycare_parent GET      /daycare_parents/:id/edit(.:format)           daycare_parents#edit
#                     daycare_parent GET      /daycare_parents/:id(.:format)                daycare_parents#show
#                                    PATCH    /daycare_parents/:id(.:format)                daycare_parents#update
#                                    PUT      /daycare_parents/:id(.:format)                daycare_parents#update
#                                    DELETE   /daycare_parents/:id(.:format)                daycare_parents#destroy
#      set_manager_password_password GET      /passwords/:id/set_manager_password(.:format) passwords#set_manager_password
#       set_worker_password_password GET      /passwords/:id/set_worker_password(.:format)  passwords#set_worker_password
#       set_parent_password_password GET      /passwords/:id/set_parent_password(.:format)  passwords#set_parent_password
#              set_password_password POST     /passwords/:id/set_password(.:format)         passwords#set_password
#                    share_todo_todo GET      /todos/:id/share_todo(.:format)               todos#share_todo
#        share_with_departments_todo GET|POST /todos/:id/share_with_departments(.:format)   todos#share_with_departments
#            share_with_workers_todo GET|POST /todos/:id/share_with_workers(.:format)       todos#share_with_workers
#            share_with_parents_todo GET|POST /todos/:id/share_with_parents(.:format)       todos#share_with_parents
#                   accept_todo_todo POST     /todos/:id/accept_todo(.:format)              todos#accept_todo
#                       search_todos GET      /todos/search(.:format)                       todos#search
#                              todos GET      /todos(.:format)                              todos#index
#                                    POST     /todos(.:format)                              todos#create
#                           new_todo GET      /todos/new(.:format)                          todos#new
#                          edit_todo GET      /todos/:id/edit(.:format)                     todos#edit
#                               todo GET      /todos/:id(.:format)                          todos#show
#                                    PATCH    /todos/:id(.:format)                          todos#update
#                                    PUT      /todos/:id(.:format)                          todos#update
#                                    DELETE   /todos/:id(.:format)                          todos#destroy
#                        admin_login GET|POST /admin/login(.:format)                        admin/admin#login
#                    admin_dashboard GET      /admin/dashboard(.:format)                    admin/admin#dashboard
#             admin_select_privilege GET      /admin/select_privilege(.:format)             admin/admin#select_privilege
#                admin_set_privilege GET|POST /admin/set_privilege(.:format)                admin/admin#set_privilege
#                admin_functionality GET      /admin/functionality(.:format)                admin/admin#functionality
#         admin_fetch_customer_types GET      /admin/fetch_customer_types(.:format)         admin/admin#fetch_customer_types
#              admin_fetch_customers GET      /admin/fetch_customers(.:format)              admin/admin#fetch_customers
#         import_new_admin_customers GET      /admin/customers/import_new(.:format)         admin/customers#import_new
#             import_admin_customers POST     /admin/customers/import(.:format)             admin/customers#import
# add_customer_types_admin_customers GET|POST /admin/customers/add_customer_types(.:format) admin/customers#add_customer_types
#        notify_users_admin_customer GET|POST /admin/customers/:id/notify_users(.:format)   admin/customers#notify_users
#                  todos_admin_todos GET      /admin/todos/todos(.:format)                  admin/todos#todos
#          todo_assignee_admin_todos GET      /admin/todos/todo_assignee(.:format)          admin/todos#todo_assignee
#                 search_admin_todos GET      /admin/todos/search(.:format)                 admin/todos#search
#                        admin_todos GET      /admin/todos(.:format)                        admin/todos#index
#                                    POST     /admin/todos(.:format)                        admin/todos#create
#                     new_admin_todo GET      /admin/todos/new(.:format)                    admin/todos#new
#                    edit_admin_todo GET      /admin/todos/:id/edit(.:format)               admin/todos#edit
#                         admin_todo GET      /admin/todos/:id(.:format)                    admin/todos#show
#                                    PATCH    /admin/todos/:id(.:format)                    admin/todos#update
#                                    PUT      /admin/todos/:id(.:format)                    admin/todos#update
#                                    DELETE   /admin/todos/:id(.:format)                    admin/todos#destroy
#                      api_api_helps GET      /api/help(.:format)                           api/api_helps#index
#                       api_v1_login POST     /api/v1/login(.:format)                       api/v1/sessions#create
#                      api_v1_signup POST     /api/v1/signup(.:format)                      api/v1/registrations#create
#            api_v1_daycare_managers GET      /api/v1/daycare_managers(.:format)            api/v1/daycare_managers#index
#                                    POST     /api/v1/daycare_managers(.:format)            api/v1/daycare_managers#create
#         new_api_v1_daycare_manager GET      /api/v1/daycare_managers/new(.:format)        api/v1/daycare_managers#new
#        edit_api_v1_daycare_manager GET      /api/v1/daycare_managers/:id/edit(.:format)   api/v1/daycare_managers#edit
#             api_v1_daycare_manager GET      /api/v1/daycare_managers/:id(.:format)        api/v1/daycare_managers#show
#                                    PATCH    /api/v1/daycare_managers/:id(.:format)        api/v1/daycare_managers#update
#                                    PUT      /api/v1/daycare_managers/:id(.:format)        api/v1/daycare_managers#update
#                                    DELETE   /api/v1/daycare_managers/:id(.:format)        api/v1/daycare_managers#destroy
#             api_v1_daycare_workers GET      /api/v1/daycare_workers(.:format)             api/v1/daycare_workers#index
#                                    POST     /api/v1/daycare_workers(.:format)             api/v1/daycare_workers#create
#          new_api_v1_daycare_worker GET      /api/v1/daycare_workers/new(.:format)         api/v1/daycare_workers#new
#         edit_api_v1_daycare_worker GET      /api/v1/daycare_workers/:id/edit(.:format)    api/v1/daycare_workers#edit
#              api_v1_daycare_worker GET      /api/v1/daycare_workers/:id(.:format)         api/v1/daycare_workers#show
#                                    PATCH    /api/v1/daycare_workers/:id(.:format)         api/v1/daycare_workers#update
#                                    PUT      /api/v1/daycare_workers/:id(.:format)         api/v1/daycare_workers#update
#                                    DELETE   /api/v1/daycare_workers/:id(.:format)         api/v1/daycare_workers#destroy
#             api_v1_daycare_parents GET      /api/v1/daycare_parents(.:format)             api/v1/daycare_parents#index
#                                    POST     /api/v1/daycare_parents(.:format)             api/v1/daycare_parents#create
#          new_api_v1_daycare_parent GET      /api/v1/daycare_parents/new(.:format)         api/v1/daycare_parents#new
#         edit_api_v1_daycare_parent GET      /api/v1/daycare_parents/:id/edit(.:format)    api/v1/daycare_parents#edit
#              api_v1_daycare_parent GET      /api/v1/daycare_parents/:id(.:format)         api/v1/daycare_parents#show
#                                    PATCH    /api/v1/daycare_parents/:id(.:format)         api/v1/daycare_parents#update
#                                    PUT      /api/v1/daycare_parents/:id(.:format)         api/v1/daycare_parents#update
#                                    DELETE   /api/v1/daycare_parents/:id(.:format)         api/v1/daycare_parents#destroy
#

Rails.application.routes.draw do

  devise_for :users

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

  resources :daycare_workers do
    collection do
      match :login, via: [:get, :post]
      get   :search_daycare
      post  :select_department
      post  :signup
      post  :finish_signup
    end
    member do
      get :dashboard
    end
  end

  resources :daycare_parents do
    collection do
      match :login, via: [:get, :post]
    end
    member do
      get :dashboard
    end
  end

  resources :passwords, only: [] do
    member do
      get :set_manager_password
      get :set_worker_password
      get :set_parent_password
      post :set_password
    end
  end
  
  resources :todos do
    member do
      get :share_todo
      match :share_with_departments, via: [:get, :post]
      match :share_with_workers, via: [:get, :post]
      match :share_with_parents, via: [:get, :post]
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



  ############################## APIs ROUTES ###########################################
  namespace :api, path: 'api' do
    resources :api_helps, :only => [:index], path: 'help'

    namespace :v1, path: 'v1' do
      post 'login'  => 'sessions#create',       as: :login
      post 'signup' => 'registrations#create',  as: :signup

      resources :daycare_managers do
      end

      resources :daycare_workers do
      end
      
      resources :daycare_parents do
      end
    end
  end
  #######################################################################################

end
