Rails.application.routes.draw do
  #mount_devise_token_auth_for 'User', at: 'auth'

  root 'landing#index'
  resources :products
  resources :categories
  resources :products, only: [:index], defaults: { category_id: nil }

  resources :order_items, path: '/cart_items', only: [:index, :new, :create, :edit, :update, :destroy]


  post '/cart_items/add_to_cart/:product_id', to: 'order_items#add_to_cart', as: 'add_to_cart'
  get '/cart_items/show_cart', to: 'order_items#show_cart', as: 'show_cart'
  put '/cart_items/update_quantity/:id', to: 'order_items#update_quantity', as: 'update_quantity_order_item'
  get '/order_items/show', to: 'order_items#show', as: 'show'
  get '/resumen', to: 'order_items#resumen', as: 'resumen'

end
