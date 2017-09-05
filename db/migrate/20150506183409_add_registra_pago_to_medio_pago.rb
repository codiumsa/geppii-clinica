class AddRegistraPagoToMedioPago < ActiveRecord::Migration
  def change
    add_column :medio_pagos, :registra_pago, :boolean
  end
end
