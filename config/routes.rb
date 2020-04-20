


Store::Application.routes.draw do
  resources :categories
  resources :orders
  resources :products


  # User routes
  root 'user#index'
  post '/users' => 'user#create'
  get 'profile' => 'user#profile'
  post '/sessions' => 'sessions#create'
  post 'profile' => 'user#accountdetails'
  get 'forgotpassword' => 'user#forgotpassword'
  post 'user/sendmail' => 'user#sendmail'
  get 'changepassword' => 'user#changepassword'
  post 'user/resetpassword' => 'user#resetpassword'
  post 'user/viewprofile' => 'user#viewprofile'
  post 'user/saveprofile' => 'user#saveprofile'

  #Product routes
  
  post 'products/filter' => 'products#filter'
  post 'products/reset' => 'products#reset'
  post 'products/buy' => 'products#buy'
  get 'dashboard' => 'products#dashboard'

 #Categories routes
  post 'categories/viewproducts' => 'categories#viewproducts'
  get '/viewproducts' => 'categories#view'

  #Order routes
  post 'orders/purchase' => 'orders#purchase'


  #Logout
  get '/logout' => 'sessions#destroy'


  #404error
  get '*unmatched_route', to: 'errors#show'

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
