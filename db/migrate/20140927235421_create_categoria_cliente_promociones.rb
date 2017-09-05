class CreateCategoriaClientePromociones < ActiveRecord::Migration
  def change
    create_table :categoria_clientes_promociones do |t|
      t.references :categoria_cliente, index: true
      t.references :promocion, index: true

      t.timestamps
    end
  end
end
