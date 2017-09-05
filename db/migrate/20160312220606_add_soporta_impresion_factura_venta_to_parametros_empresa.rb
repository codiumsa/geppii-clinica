class AddSoportaImpresionFacturaVentaToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_impresion_factura_venta, :boolean, default: true
  end
end
