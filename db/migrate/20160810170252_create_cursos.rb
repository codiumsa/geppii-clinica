class CreateCursos < ActiveRecord::Migration
  def change
    create_table :cursos do |t|
      t.string :descripcion
      t.string :observaciones
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.timestamps
    end
  end
end
