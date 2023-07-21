# config/routes.rb
Rails.application.routes.draw do
  root 'landing#index'
  resources :products
  resources :categories
  resources :products, only: [:index], defaults: { category_id: nil }

  # Ruta para mostrar el carrito
  resources :order_items, path: '/cart_items', only: [:index]
end
