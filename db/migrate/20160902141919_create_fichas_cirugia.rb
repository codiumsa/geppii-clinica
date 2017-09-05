class CreateFichasCirugia < ActiveRecord::Migration
  def change
    create_table :fichas_cirugia do |t|
      t.references :paciente, index: true
      t.references :colaborador, index: true
      t.datetime :fecha_consulta_inicial
      t.string :diagnostico_inicial
      t.timestamps
    end
  end
end
