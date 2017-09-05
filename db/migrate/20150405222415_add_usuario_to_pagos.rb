class AddUsuarioToPagos < ActiveRecord::Migration
  def change
    add_reference :pagos, :usuario_aprobacion_descuento, index: true
  end
end
