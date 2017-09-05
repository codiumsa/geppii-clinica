class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.references :persona, index: true
      t.integer :numero_cliente
      t.boolean :activo
      t.references :calificacion, index: true
      t.float :antiguedad
      t.float :salario_mensual
      t.string :matricula_nro
      t.string :ramo
      t.float :otros_ingresos
      t.string :empleador
      t.string :pariente1
      t.string :pariente2
      t.float :ingreso_pariente2
      t.string :domicilio
      t.string :cargo
      t.string :telefono
      t.string :jubilado
      t.string :institucion
      t.string :comerciante
      t.boolean :empleado
      t.string :profesion
      t.string :actividad_empleador
      t.string :direccion_empleador
      t.references :ciudad, index: true
      t.string :barrio_empleador
      t.date :fecha_pago_sueldo
      t.string :concepto_otros_ingresos
      t.boolean :ips
      t.date :fecha_ingreso_informconf
      t.date :fecha_egreso_informconf

      t.timestamps
    end
  end
end
