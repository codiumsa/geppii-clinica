class AddCodigoLocalToProducto < ActiveRecord::Migration
  def change
      add_column :productos, :codigo_local, :string
  end
end
