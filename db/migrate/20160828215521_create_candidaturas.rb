class CreateCandidaturas < ActiveRecord::Migration
  def change
    create_table :candidaturas do |t|
      t.references :paciente, index: true
      t.references :especialidad, index: true
      t.references :colaborador, index: true
      t.date :fecha
      t.boolean :clinica
      t.references :campanha, index: true
      t.date :fecha_posible

      t.timestamps
    end
  end
end
