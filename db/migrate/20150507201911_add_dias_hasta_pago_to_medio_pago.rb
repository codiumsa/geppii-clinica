class AddDiasHastaPagoToMedioPago < ActiveRecord::Migration
  def change
    add_column :medio_pagos, :dias_hasta_pago, :integer
  end
end
