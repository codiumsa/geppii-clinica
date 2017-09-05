class CreateCompraMedios < ActiveRecord::Migration
  def change
    create_table :compra_medios do |t|
      t.references :compra, index: true
      t.references :tarjeta, index: true
      t.references :medio_pago, index: true
      t.string :nro_cheque
      t.references :cuenta, index: true
      t.timestamps
    end
  end
end
