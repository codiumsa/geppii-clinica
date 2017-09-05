class AddUsuarioToPago < ActiveRecord::Migration
  def change
    add_reference :pagos, :usuario_solicitud_descuento, index: true
  end
end
