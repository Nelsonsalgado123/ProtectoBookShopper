class AddImagePathToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :image_path, :string, default: "ruta_por_defecto"
  end
end
