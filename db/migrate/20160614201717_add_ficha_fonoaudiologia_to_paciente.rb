class AddFichaFonoaudiologiaToPaciente < ActiveRecord::Migration
  def change
    add_reference :pacientes, :fonoaudiologia, index: true
  end
end
