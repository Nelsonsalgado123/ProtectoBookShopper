# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, optional: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.add_to_cart(product_id, quantity = 1)
    product = Product.find(product_id)
    current_cart = Cart.first_or_create

    order_item = current_cart.order_items.find_by(product_id: product_id)

    if order_item
      order_item.quantity += quantity
    else
      order_item = current_cart.order_items.new(product: product, quantity: quantity, price: product.price, image: product.image)
    end

    order_item.save
    current_cart.save
  end
end
