Rails.application.routes.draw do
  resources :user_profiles, only: [:index, :show, :edit, :update]

  resources :forum_threads

  resources :news

  resources :events do
    post :open, on: :member
    post :close, on: :member

    resources :replies, only: [:index] do
      get :edit_multiple, on: :collection
      put :update_multiple, on: :collection
    end

    resource :report, only: [:show, :new]
  end

  resources :league_matches, controller: 'events', type: 'LeagueMatch', only: [:create, :edit, :update]
  resources :cup_matches, controller: 'events', type: 'CupMatch', only: [:create, :edit, :update]
  resources :others, controller: 'events', type: 'Other', only: [:create, :edit, :update]

  resources :replies, only: [:create, :update]

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:index, :update]
  resources :teams, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :reports, only: [:index, :new, :create, :edit, :update]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#welcome'

  get '/fussball_de' => 'pages#fussball_de'
  get '/contact' => 'pages#contact'

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
