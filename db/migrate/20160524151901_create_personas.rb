class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :nombre
      t.string :apellido
      t.string :ci_ruc
      t.string :razon_social
      t.string :tipo_persona
      t.string :sexo
      t.string :estado_civil
      #t.references :conyugue, index: true
      t.string :nacionalidad
      t.string :telefono
      t.string :celular
      t.string :correo
      t.integer :ciudad_id
      t.string :barrio
      t.string :direccion
      t.string :tipo_domicilio
      t.float :antiguedad_domicilio
      t.string :fecha_nacimiento
      t.string :date
      t.integer :numero_hijos
      t.string :estudios_realizados

      t.timestamps
    end
  end
end
