Rails.application.routes.draw do
  get 'api/v1'
  get 'api/citylists' 
  root 'dashboard#index'
  get '/dashboard' => 'dashboard#index'
  get '/users/sign_in' => "sessions#new"
  post '/users/sign_in' => "sessions#create"
  get '/users/sign_out' => "sessions#destroy"
  get '/organization/edit' => "organizations#edit"
  put '/organization' => "organizations#update"
  post '/maps' => "maps#index"
  get '/schema' => "schema#index"
  get '/users/filter' => "users#index"
  post '/users/filter' => "users#index"
  get '/retailers/zed_sales'
  post '/maps/map_data'
 
   
  resources :weekly_offs, :only => [:index, :create]

  resources :job_titles, :except => [:show]
  
  resources :departments, :except => [:show]

  resources :regions, :except => [:show]

  resources :business_units, :except => [:show]

  resources :data_files, :only => [:index]

  resources :folders, :except => [:index]

  resources :attendances, :only => [:index]

  resources :vendor_tasks, :only => [:index,:new,:create,:edit,:update]

  resources :retailers, :only => [:index,:new,:edit,:destroy,:create,:update,:show]

  resources :vendorlists, :only => [:index,:new,:edit,:destroy,:create,:update,:show]

  resources :cmos, :only => [:index,:new,:edit,:destroy,:create,:update,:show]

  resources :maps, :only => [:index]

  resources :vendor_requests, :only => [:index,:new,:edit,:destroy,:create,:update,:show]

  resources :vendor_assignments, :only => [:index,:edit,:accept,:show,:update]

  resources :beatroutes, :only => [:index,:new,:edit,:create,:update,:show]

  resources :repositories, :only => [:index,:new,:edit,:create,:update,:show]

  resources :tags, :only => [:index,:new,:create]

  resources :notifications, :only => [:index,:new,:create]

  resources :devices, :only => [:index]

  resources :helps, :only => [:index]

  resources :read_files do
    collection { post :import }
  end

  resources :retailers do
    collection { post :file_upload }
  end

  resources :documents, :only => [:index,:new,:create]
    
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

    resources :requests, :only => [:index, :edit, :update, :new, :create] do
    get :autocomplete_retailer_code, :on => :collection
  end

  resources :customers_users, :only => [:new, :create, :destroy]
  
  resources :cities, :item_regions, :categories, :collections, :sizes, :alcohol_percents, :images, :warehouses,:items, :screens, :fields, :surveys, :holidays, :roles, :permissions, :apps, :except => [:show]
  
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

  resources :rrms

  get '/passwords/edit' => "passwords#edit"
  put '/passwords' => "passwords#update"
  get '/passwords/new' => "passwords#new"
  post '/passwords' => "passwords#create"


  namespace :api, :defaults => { :format => :json }, :constraints => {:format => :json} do
    namespace :v1 do
      get '/test' => 'test#index'
      post '/response/parser'
      post 'sessions/create'
      post 'retailerlists/retailers'
      get 'retailerlists/retailers'
      get '/statelists' => 'statelists#index'
      post 'retailerlists/search_retailer'
      get 'retailerlists/search_retailer'
      get 'sessions/create'
      delete 'sessions/destroy'
      get '/home' => 'home#index'
      post 'sessions/forgot_password'
      get 'sessions/forgot_password'
      post '/sessions' => 'sessions#index'
      post 'sessions/edit'
      post 'sessions/change_password'
      get 'sessions/change_password'
      post 'vendors/assign_request'
      get 'vendors/assign_request'
      post 'vendors/get_request'
      get 'vendors/get_request'
      post 'vendors/get_request_status'
      get 'vendors/get_request_status'
      post 'vendors/update_request_status'
      get 'vendors/update_request_status'
      post 'vendors/reject_request'
      get 'vendors/reject_request'
      post 'vendors/accept_request'
      get 'vendors/accept_request'
      post 'devices/registration'
      post 'devices/update'
      get 'documents/list'
      get '/repository' => 'repository#index'
      get '/repository/tag' => 'repository#tag_name'
      get '/repository/uploader' => 'repository#uploaded_by'
      get '/repository/search' => 'repository#search'
            
      resources :attendances, :only => [:create]
      resources :citylists, :only =>[:index]
      resources :radiofields, :only =>[:index]
      resources :visitors, :only =>[:index]
      resources :retailerlists, :only =>[:index]
      resources :shop_assignments, :only => [:index,:create]
      post '/shop_assignments/:id/audited' => "shop_assignments#audited"
     
      resources :version, :only => [:index]
        
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
    # resources :documents, :except => [:index] do
    #   put :share, :on => :member
    # end
    post '/passwords' => "passwords#create"
    put '/passwords' => "passwords#update"
    resources :customers, :only => [:index, :update, :create] do
    resources :contacts, :only => [:create, :update, :destroy]
    end
    resources :surveys, :only => [:index]
    resources :answers, :only => [:create]
    resources :vendor_tasks, :only => [:index,:edit,:update,:new, :create]

    resources :requests, :only => [:new, :create] do
      get :autocomplete_retailer_code, :on => :collection
    end
    resources :dropdown_values, :only => [:index]

  end

  post '/cmos/file_upload' 
  post '/retailers/search'
  post '/users/search'

  get '/requests/state'
  get '/requests/city'
  post 'requests/modify'
  post '/requests/view' 
  post '/vendor_tasks/view'
 
  post '/retailers/file_upload'
  post '/retailers/file_insert'
  
  get "vendor_assignments/:id/status" => "vendor_assignments#status"

  post '/downloads' => 'downloads#create'
  get '/downloads' => 'downloads#index'
  get '/downloads/new' => "downloads#new"
  get '/downloads/:file_name' => 'downloads#show', :as => 'download'

  post '/requests_csv' => 'requests_csv#create'
  get '/requests_csv/new' => "requests_csv#new"
  get '/requests_csv/:file_name' => 'requests_csv#show', :as => 'request_csv'

  post 'requests/previous_month_sales' 
  get 'requests/previous_month_sales' 

  post 'requests/retailer_requests' 
  get 'requests/retailer_requests'

  post 'beatroutes/file_upload'
  get 'beatroutes/file_upload'

  get 'tags/create'

  namespace :api, :defaults => { :format => :json }, :constraints => {:format => :json} do
    namespace :gpulse do
      get '/maps' => 'maps#index'
      get '/cmos' => 'cmos#index'
      get '/statelists' => 'statelists#index'
      post 'requests/shop_branding'
      post 'requests/shop_list'
      post 'requests/request_data'
      get 'requests/shop_info'   
    end
  end 
   
  resources :user_data, :only =>[:new,:create,:index]

  namespace :api, :defaults => {:format => :json},:constraints => {:format => :json} do
    namespace :gstar do
      get '/shops/ndList'
      get '/shops/rdList'
      get '/shops/shopList'
    end
  end 

  namespace :api,:defaults => {format: :json},constraints: {format: :json} do
    namespace :gquestion do
      resources :retailers , only: [:index]
    end
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
#######################################new design routes##############################
  get '/dashboard/new'
 
  get '/users/change_status'

  get '/users/reset_password'
  post '/users/reset_password' => 'users#change_password' 

  get '/retailers/filter' => "retailers#index"
   resources :users,:only => [:show,:index]
   resources :shop_assignments
   resources :user_audits
   post '/shop_assignments/search'


end
