class AddEstimulosToFichaFonoaudiologia < ActiveRecord::Migration
  def change
    add_column :fichas_fonoaudiologia, :estimulos, :jsonb
  end
end
