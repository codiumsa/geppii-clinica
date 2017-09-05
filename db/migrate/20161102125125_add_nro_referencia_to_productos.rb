class AddNroReferenciaToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :nro_referencia, :string
  end
end
