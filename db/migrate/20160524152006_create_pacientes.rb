class CreatePacientes < ActiveRecord::Migration
  def change
    create_table :pacientes do |t|
      t.references :persona, index: true
      t.string :numero_paciente

      t.timestamps
    end
  end
end
