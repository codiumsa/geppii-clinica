class CreateCuentas < ActiveRecord::Migration
  def change
    create_table :cuentas do |t|
      t.string :banco
      t.string :nro_cuenta
      t.references :moneda, index: true
      t.timestamps
    end
  end
end
