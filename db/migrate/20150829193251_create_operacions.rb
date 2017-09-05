class CreateOperacions < ActiveRecord::Migration
  def change
		create_table :operaciones do |t|
      t.string :tipo_operacion
      t.float :monto
      t.references :caja, index: true
      t.references :caja_destino, index: true
      t.references :moneda, index: true

      t.timestamps
    end
  end
end
