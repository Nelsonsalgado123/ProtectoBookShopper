class ApplicationController < ActionController::Base
  helper_method :current_cart, :cart_quantity

  def current_cart
    @current_cart ||= Cart.first_or_create
  end

  def cart_quantity
    @current_cart.cart_items.sum(:quantity) if @current_cart
  end
end
