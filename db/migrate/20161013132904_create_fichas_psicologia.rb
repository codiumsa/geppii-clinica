class CreateFichasPsicologia < ActiveRecord::Migration
  def change
    create_table :fichas_psicologia do |t|
      t.references :paciente, index: true
      t.integer :nro_ficha
      t.string :estado
    end
  end
end
