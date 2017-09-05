class CreateProcesos < ActiveRecord::Migration
  def change
    create_table :procesos do |t|
      t.references :producto, index: true
      t.integer :cantidad
      t.string :descripcion
      t.string :estado

      t.timestamps
    end
  end
end
