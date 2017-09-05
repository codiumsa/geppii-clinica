class AddLoteToCompraDetalle < ActiveRecord::Migration
  def change
      add_reference :compra_detalles, :lote , index: true
  end
end