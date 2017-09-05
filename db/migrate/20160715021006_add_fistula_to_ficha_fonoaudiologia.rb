class AddFistulaToFichaFonoaudiologia < ActiveRecord::Migration
  def change
    add_column :fichas_fonoaudiologia, :fistula, :jsonb
  end
end
