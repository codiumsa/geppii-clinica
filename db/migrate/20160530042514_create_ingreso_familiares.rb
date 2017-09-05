class CreateIngresoFamiliares < ActiveRecord::Migration
  def change
    create_table :ingreso_familiares do |t|
      t.float :ingreso_mensual
      t.references :vinculo_familiar, index: true
      t.references :cliente, index: true

      t.timestamps
    end
  end
end
