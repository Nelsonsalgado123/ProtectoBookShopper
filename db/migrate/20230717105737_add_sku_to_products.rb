class AddSkuToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sku, :string
  end
end
