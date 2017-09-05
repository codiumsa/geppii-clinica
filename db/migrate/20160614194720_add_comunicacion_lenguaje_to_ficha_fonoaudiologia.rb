class AddComunicacionLenguajeToFichaFonoaudiologia < ActiveRecord::Migration
  def change
    add_column :fichas_fonoaudiologia, :comunicacion_lenguaje, :jsonb
  end
end
