class AddEspecialidadToTratamiento < ActiveRecord::Migration
  def change
    add_reference :tratamientos, :especialidad, index: true
  end
end
