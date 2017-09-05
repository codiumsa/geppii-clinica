class AddEstadoToFichasFonoaudiologia < ActiveRecord::Migration
  def change
    add_column :fichas_fonoaudiologia, :estado, :string
    add_column :fichas_fonoaudiologia, :nro_ficha, :integer
  end
end
