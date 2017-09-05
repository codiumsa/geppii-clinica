class CreateConsultas < ActiveRecord::Migration
  def change
    create_table :consultas do |t|
      t.references :colaborador, index: true
      t.references :especialidad, index: true
      t.datetime :fecha_agenda
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.string :estado
      t.boolean :cobrar
      t.timestamps
    end
  end
end
