class AddCodigoExternoToProducto < ActiveRecord::Migration
  def change
      add_column :productos, :codigo_externo, :string
  end
end
