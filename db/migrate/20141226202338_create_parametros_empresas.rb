class CreateParametrosEmpresas < ActiveRecord::Migration
  def change
    create_table :parametros_empresas do |t|
      t.boolean :imei_en_venta_detalle

      t.timestamps
    end
  end
end
