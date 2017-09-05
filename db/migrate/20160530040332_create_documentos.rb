class CreateDocumentos < ActiveRecord::Migration
  def change
    create_table :documentos do |t|
      t.references :cliente, index: true
      t.references :tipo_documento, index: true
      t.string :nombre
      t.string :estado
      t.string :nombre_archivo
      t.binary :archivo

      t.timestamps
    end
  end
end
