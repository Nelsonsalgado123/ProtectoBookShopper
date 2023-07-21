class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.string :image

      t.timestamps
    end
  end
end
