class RenameNroFichaOfConsultaDetalle < ActiveRecord::Migration
  def change
    rename_column :consulta_detalles, :nro_ficha, :id_ficha
  end
end
