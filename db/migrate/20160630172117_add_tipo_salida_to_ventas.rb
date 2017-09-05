class AddTipoSalidaToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :tipo_salida, index: true
  end
end
