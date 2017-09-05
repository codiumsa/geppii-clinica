class AddCajaDefaultToTipoOperacion < ActiveRecord::Migration
  def change
    add_column :tipos_operacion, :caja_default, :string, default: "usuario"
  end
end
