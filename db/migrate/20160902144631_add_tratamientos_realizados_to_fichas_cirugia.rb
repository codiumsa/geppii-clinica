class AddTratamientosRealizadosToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :tratamientos_realizados, :jsonb
  end
end
