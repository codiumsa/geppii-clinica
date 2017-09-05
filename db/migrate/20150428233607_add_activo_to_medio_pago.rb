class AddActivoToMedioPago < ActiveRecord::Migration
  def change
  	add_column :medio_pagos, :activo, :boolean
  end
end
