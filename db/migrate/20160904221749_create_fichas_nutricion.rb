class CreateFichasNutricion < ActiveRecord::Migration
  def change
    create_table :fichas_nutricion do |t|
      t.references :paciente, index: true
      t.integer :nro_ficha
      t.column :datos, :jsonb   # Edited
      t.string :estado, index:true
      t.timestamps
    end
  end
end
