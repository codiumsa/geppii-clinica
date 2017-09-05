class AddDiagnosticosRealizadosToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :diagnosticos_realizados, :jsonb
  end
end
