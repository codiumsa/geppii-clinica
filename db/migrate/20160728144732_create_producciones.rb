class CreateProducciones < ActiveRecord::Migration
  def change
    create_table :producciones do |t|
      t.references :producto, index: true
      t.integer :cantidad_a_producir
      t.timestamps
    end
  end
end
