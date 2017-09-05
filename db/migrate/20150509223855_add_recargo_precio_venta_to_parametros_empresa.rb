class AddRecargoPrecioVentaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :recargo_precio_venta, :boolean
  end
end
