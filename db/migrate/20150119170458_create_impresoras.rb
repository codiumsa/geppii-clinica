class CreateImpresoras < ActiveRecord::Migration
  def change
    create_table :impresoras do |t|
      t.string :nombre
      t.string :tipo_documento
      t.string :tamanho_hoja
      t.text :descripcion

      t.timestamps
    end
  end
end
