class AddAlimentacionToFichaFonoaudiologia < ActiveRecord::Migration
  def change
    add_column :fichas_fonoaudiologia, :alimentacion, :jsonb
  end
end
