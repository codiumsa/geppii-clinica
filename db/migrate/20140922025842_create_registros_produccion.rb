class CreateRegistrosProduccion < ActiveRecord::Migration
  def change
    create_table :registros_produccion do |t|
      t.references :proceso, index: true
      t.integer :cantidad
      t.string :estado
      t.date :fecha

      t.timestamps
    end
  end
end
