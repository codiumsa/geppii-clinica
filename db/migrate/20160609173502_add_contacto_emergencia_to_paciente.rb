class AddContactoEmergenciaToPaciente < ActiveRecord::Migration
  def change
    add_column :pacientes, :contacto_emergencia, :jsonb
  end
end
