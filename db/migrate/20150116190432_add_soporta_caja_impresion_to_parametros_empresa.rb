class AddSoportaCajaImpresionToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :soporta_caja_impresion, :boolean
  end
end
