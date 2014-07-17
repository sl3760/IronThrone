Rails.application.routes.draw do
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

  resources :episodes

  resources :users

  resources :sessions, only: [:new, :create, :destroy]

  match "/renders/dashboard", to:"renders#dashboard", via: 'get'

  match "/upload", to: "episodes#new",  via: 'get' 

  root to: "renders#home"

  match "/renders/estimate", to: "renders#estimate", via: 'get'

  match "/renders/produce", to: "renders#produce", via: 'post'

  match '/signup', to: 'users#new', via:'get'

  match '/signin', to: 'sessions#new', via:'get'

  match '/signout', to: 'sessions#destroy', via: 'delete'

  match '/about', to: 'renders#about', via: 'get'

  match '/contact', to: 'renders#contact', via: 'get'

  match '/profile', to: 'profiles#index', via: 'get'

  match '/profiles/modification', to: 'profiles#modification', via: 'get'

  match 'profiles/modify', to: 'profiles#modify', via: 'post'

  match 'profiles/history', to: 'profiles#history', via: 'get'

  match 'profiles/delete/history', to: 'profiles#delete_history', via: 'post'

  match 'profiles/collection', to: 'profiles#collection', via: 'get'

  match 'profiles/collect', to: 'profiles#collect', via: 'post'

  match 'profiles/delete/collection', to: 'profiles#delete_collection', via: 'post'

  match 'profiles/subscription', to: 'profiles#subscription', via: 'get'

  match 'profiles/feeding', to: 'profiles#feeding', via: 'post'

  match 'profiles/subscribe', to: 'profiles#subscribe', via: 'post'

  match 'profiles/cancel/subscription', to: 'profiles#cancel_subscription', via: 'post'

  match 'profiles/whisper', to: 'profiles#whisper', via: 'get'

  match 'profiles/make/whisper', to: 'profiles#make_whisper', via: 'post'

  match 'profiles/reply', to: 'profiles#reply', via: 'post'

  match 'profiles/make/reply', to: 'profiles#make_reply', via: 'post'

  match 'profiles/delete/whisper', to: 'profiles#delete_whisper', via: 'post'

  match 'profiles/settings', to: 'profiles#settings', via: 'get'

  match 'profiles/toggle/history', to: 'profiles#toggle_history', via: 'post'

  match 'profiles/toggle/whisper', to: 'profiles#toggle_whisper', via: 'post'

  match "/renders/sort", to: "renders#sort", via: 'get'
end