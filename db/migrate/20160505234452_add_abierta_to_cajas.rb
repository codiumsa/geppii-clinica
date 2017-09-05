class AddAbiertaToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :abierta, :boolean, default: false
  end
end
