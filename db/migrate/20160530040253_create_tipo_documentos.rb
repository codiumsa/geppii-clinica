class CreateTipoDocumentos < ActiveRecord::Migration
  def change
    create_table :tipo_documentos do |t|
      t.string :nombre

      t.timestamps
    end
    add_index :tipo_documentos, :nombre, unique: true
  end
end
