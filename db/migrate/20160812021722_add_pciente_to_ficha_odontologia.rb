class AddPcienteToFichaOdontologia < ActiveRecord::Migration
  def change
    add_reference :fichas_odontologia, :paciente, index: true
  end
end
