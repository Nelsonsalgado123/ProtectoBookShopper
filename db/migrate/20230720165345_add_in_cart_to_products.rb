class AddInCartToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :in_cart, :boolean
  end
end
