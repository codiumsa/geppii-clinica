class AddSoportaImpresionReciboToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_impresion_recibo, :boolean, default: false
  end
end
