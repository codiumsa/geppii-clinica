class AddPacienteToFichaFonoaudiologia < ActiveRecord::Migration
  def change
    add_reference :fichas_fonoaudiologia, :paciente, index: true
  end
end
