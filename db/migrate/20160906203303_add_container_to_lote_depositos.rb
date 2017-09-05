class AddContainerToLoteDepositos < ActiveRecord::Migration
  def change
    add_reference :lote_depositos, :contenedor, index: true

  end
end
