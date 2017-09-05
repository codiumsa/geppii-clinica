class AddCodigoToTipoProducto < ActiveRecord::Migration
  def change
      add_column :tipo_productos, :codigo, :string
  end
end
