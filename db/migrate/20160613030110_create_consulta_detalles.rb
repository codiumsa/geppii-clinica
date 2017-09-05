class CreateConsultaDetalles < ActiveRecord::Migration
  def change
    create_table :consulta_detalles do |t|
      t.references :consulta, index: true
      t.references :producto, index: true
      t.float :cantidad
      t.timestamps
    end
  end
end
