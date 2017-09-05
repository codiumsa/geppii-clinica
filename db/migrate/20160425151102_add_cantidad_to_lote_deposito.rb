class AddCantidadToLoteDeposito < ActiveRecord::Migration
  def change
      add_column :lote_depositos, :cantidad, :integer 	
  end
end
