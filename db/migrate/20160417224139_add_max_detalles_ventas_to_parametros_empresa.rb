class AddMaxDetallesVentasToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :max_detalles_ventas, :integer, default: 30
  end
end
