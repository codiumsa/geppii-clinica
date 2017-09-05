class CreateCategoriaClientes < ActiveRecord::Migration
  def change
    create_table :categoria_clientes do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end
end
