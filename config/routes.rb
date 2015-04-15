Rails.application.routes.draw do
  root 'dashboard#index'
  get '/dashboard' => 'dashboard#index'
  get '/users/sign_in' => "sessions#new"
  post '/users/sign_in' => "sessions#create"
  delete '/users/sign_out' => "sessions#destroy"

  get '/organization/edit' => "organizations#edit"
  put '/organization' => "organizations#update"

  get '/schema' => "schema#index"

  resources :weekly_offs, :only => [:index, :create]

  resources :job_titles, :except => [:show]
  
  resources :departments, :except => [:show]

  resources :regions, :except => [:show]

  resources :business_units, :except => [:show]

  resources :data_files, :only => [:index]

  resources :folders, :except => [:index]

  resources :attendances, :only => [:index]

  resources :documents, :except => [:index] do
    put :share, :on => :member
  end
  
  resources :module_groups, :only => [:index, :edit, :update]

  resources :addresses, :except => [:show] do
    collection do
      get :edit_hq
    end
  end

  resources :users_reportings, :only => [:index] do
    get :autocomplete, :on => :collection
  end

  resources :customers, :only => [:index, :show, :edit, :update] do
    get :autocomplete, :on => :collection
    resources :contacts
  end

  resources :requests, :only => [:index, :edit, :update, :new]

  resources :customers_users, :only => [:new, :create, :destroy]
  
  resources :cities, :item_regions, :categories, :collections, :sizes, :alcohol_percents, :images, :warehouses, :screens, :fields, :surveys, :holidays, :roles, :permissions, :apps, :except => [:show]
  
  resources :items, :except => [:show] do
    get :autocomplete, :on => :collection
    resources :inventories, :except => [:show]
  end

  resources :users, :except => [:show] do
    get :autocomplete, :on => :collection
  end

  resources :user_shifts, :only => [:index, :update] do
    put :update_all, :on => :collection
  end

  get '/passwords/edit' => "passwords#edit"
  put '/passwords' => "passwords#update"
  get '/passwords/new' => "passwords#new"
  post '/passwords' => "passwords#create"

  namespace :api, :defaults => { :format => :json }, :constraints => {:format => :json} do
    namespace :v1 do
      get '/test' => 'test#index'
      post '/users/sign_in' => 'sessions#create'
      delete '/users/sign_out' => 'sessions#destroy'
      get '/home' => 'home#index'
      resources :attendances, :only => [:create]
    end
  end

  scope '/api/v1/', :as => 'api_v1', :defaults => { :format => :json }, :constraints => { :format => :json } do
    resources :categories, :item_regions, :cities, :collections, :sizes, :alcohol_percents, :images, :warehouses, :except => [:show]
    resources :screens, :only => [:index, :show]
    resources :items, :except => [:show] do
      resources :inventories, :except => [:show]
    end
    resources :data_files, :only => [:index]
    resources :folders, :except => [:index]
    resources :documents, :except => [:index] do
      put :share, :on => :member
    end
    post '/passwords' => "passwords#create"
    put '/passwords' => "passwords#update"
    resources :customers, :only => [:index, :update, :create] do
      resources :contacts, :only => [:create, :update, :destroy]
    end
    resources :surveys, :only => [:index]
    resources :answers, :only => [:create]
    resources :requests, :only => [:new, :create] do
      get :autocomplete_retailer_code, :on => :collection
    end
    resources :dropdown_values, :only => [:index]
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
