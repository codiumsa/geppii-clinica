class CreateAjusteInventarioDetalles < ActiveRecord::Migration
  def change
    create_table :ajuste_inventario_detalles do |t|
      t.integer :cantidad

      t.timestamps
    end
  end
end
