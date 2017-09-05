class AddCajaImpresionRefToImpresoras < ActiveRecord::Migration
  def change
    add_reference :impresoras, :caja_impresion, index: true
  end
end
