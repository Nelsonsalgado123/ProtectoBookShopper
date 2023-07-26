# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :order_items, dependent: :destroy

  # This method will add a product to the cart or update its quantity if it's already in the cart
  def add_item(product_id, name, quantity, price, image)
    order_item = order_items.find_by(product_id: product_id)

    if order_item
      order_item.update(quantity: order_item.quantity + quantity)
    else
      order_item = order_items.new(product_id: product_id, name: name, quantity: quantity, price: price, image: image)
    end

    order_item
  end

  def total_items
    order_items.sum(:quantity)
  end

  def total_price
    order_items.sum { |item| item.quantity * item.price }
  end
end
