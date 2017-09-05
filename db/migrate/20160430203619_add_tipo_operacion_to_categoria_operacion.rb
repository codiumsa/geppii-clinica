class AddTipoOperacionToCategoriaOperacion < ActiveRecord::Migration
  def change
    add_reference :categoria_operaciones, :tipo_operacion, index: true
  end
end
