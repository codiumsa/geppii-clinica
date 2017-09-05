class AddContenedorToCompraDetalle < ActiveRecord::Migration
  def change
    add_reference :compra_detalles, :contenedor, index: true  
  end
end
