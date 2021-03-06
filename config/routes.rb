EmoneyServer::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end
    end
  end
  
  namespace :admin do
    resources :users do
      resources :accounts
    end
    resources :syncs
  end
  resources :presence_logs
  resources :park_logs
  resources :accounts do
    member do
      get :top_up
      post :process_top_up
    end
    resources :transaction_logs do
      get :cancel, on: :member
    end
    resources :presence_logs
    resources :park_logs
  end
  resources :payers, controller: "accounts" do
    resources :transaction_logs do
      get :cancel, on: :member
    end
  end
  resources :merchants, controller: "accounts" do
    resources :transaction_logs do
      get :cancel, on: :member
    end
  end
  
  resources :park_meters, controller: "accounts" do
    resources :park_logs
  end
  
  resources :attendance_machines, controller: "accounts" do
    resources :presence_logs do
      
    end
  end
  devise_for :users
  devise_scope :user do
    get '/logout' => "devise/sessions#destroy"
    get '/profile' => "devise/registrations#edit"
  end
  
  get '/update_key' => "home#update_key"
  get '/create_account/:account' => "accounts#create_account"
  post '/sync' => "transaction_logs#sync"
  post '/register' => "accounts#register"
  post '/presence' => "presence_logs#presence"
  post '/park' => "park_logs#park"
  post '/get_key' => "accounts#get_key"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get "/dashboard" => "home#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
