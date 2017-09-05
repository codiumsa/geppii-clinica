class CreateCompraCuotas < ActiveRecord::Migration
  def change
    create_table :compra_cuotas do |t|
      t.references :compra, index: true
      t.integer :nro_cuota
      t.float :monto
      t.date :fecha_vencimiento
      t.datetime :fecha_cobro
      t.boolean :cancelado, :default => false
      t.string :nro_recibo

      t.timestamps
    end
  end
end
