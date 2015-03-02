Rails.application.routes.draw do
  
  get '/users/sign_in' => "sessions#new"
  post '/users/sign_in' => "sessions#create"
  delete '/users/sign_out' => "sessions#destroy"

  get '/organization/edit' => "organizations#edit"
  put '/organization' => "organizations#update"

  resources :weekly_offs, :only => [:index, :create]

  resources :job_titles, :except => [:show]
  
  resources :departments, :except => [:show]

  resources :regions, :except => [:show]

  resources :business_units, :except => [:show]

  resources :data_files, :only => [:index]

  resources :folders, :except => [:index]

  resources :documents, :except => [:index] do
    put :share, :on => :member
  end
  
  resources :module_groups, :only => [:index] do
    put :toggle_activation, :on => :member
  end

  resources :addresses, :except => [:show] do
    collection do
      get :edit_hq
    end
  end
  
  resources :cities, :item_regions, :categories, :collections, :sizes, :alcohol_percents, :images, :warehouses, :screens, :fields, :except => [:show]
  
  resources :items, :except => [:show] do
    get :autocomplete, :on => :collection
    resources :inventories, :except => [:show]
  end

  resources :users, :except => [:show] do
    get :autocomplete, :on => :collection
  end

  get '/passwords/edit' => "passwords#edit"
  put '/passwords' => "passwords#update"

  namespace :api, :defaults => { :format => :json }, :constraints => {:format => :json} do
    namespace :v1 do
      get '/test' => 'test#index'
      post '/users/sign_in' => 'sessions#create'
      delete '/users/sign_out' => 'sessions#destroy'
      resources :customers
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
