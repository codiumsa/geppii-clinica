class CreateCajasImpresion < ActiveRecord::Migration
  def change
    create_table :cajas_impresion do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
