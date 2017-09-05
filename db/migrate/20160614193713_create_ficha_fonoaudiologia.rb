class CreateFichaFonoaudiologia < ActiveRecord::Migration
  def change
    create_table :fichas_fonoaudiologia do |t|
      t.integer :prioridad
      t.timestamps
    end
  end
end
