class AddMontoAlivioToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :monto_alivio, :float
  end
end
