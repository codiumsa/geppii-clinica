class CreatePromociones < ActiveRecord::Migration
  def change
    create_table :promociones do |t|
      t.string :descripcion
      t.date :fecha_vigencia_desde
      t.date :fecha_vigencia_hasta
      t.float :porcentaje_descuento

      t.timestamps
    end
  end
end
