class AddCajaImpresionToAPIKeys < ActiveRecord::Migration
  def change
    add_reference :api_keys, :caja_impresion, index: true
  end
end
