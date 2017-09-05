class CreateTipoProductos < ActiveRecord::Migration
  def change
    create_table :tipo_productos do |t|
        t.string :descripcion
    end
  end
end
