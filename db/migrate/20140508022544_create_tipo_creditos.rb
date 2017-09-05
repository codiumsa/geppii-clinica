class CreateTipoCreditos < ActiveRecord::Migration
  def change
    create_table :tipo_creditos do |t|
      t.string :descripcion
      t.integer :plazo
      t.string :unidad_tiempo
      t.float :interes

      t.timestamps
    end
  end
end
