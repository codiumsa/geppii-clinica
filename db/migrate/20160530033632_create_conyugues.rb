class CreateConyugues < ActiveRecord::Migration
  def change
    create_table :conyugues do |t|
      t.string :nombre
      t.string :apellido
      t.string :nacionalidad
      t.string :cedula
      t.date :fecha_nacimiento
      t.string :lugar_nacimiento
      t.string :empleador
      t.string :actividad_empleador
      t.string :cargo
      t.string :profesion
      t.float :ingreso_mensual
      t.string :concepto_otros_ingresos
      t.float :otros_ingresos

      t.timestamps
    end
  end
end
