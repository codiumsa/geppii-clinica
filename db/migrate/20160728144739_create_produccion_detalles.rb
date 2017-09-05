class CreateProduccionDetalles < ActiveRecord::Migration
  def change
    create_table :produccion_detalles do |t|
      t.references :produccion, index: true
      t.references :producto, index: true
      t.references :lote, index: true
      t.references :deposito, index: true
      t.integer :cantidad    
      t.timestamps
    end
  end
end
