class CreateVenta < ActiveRecord::Migration
  def up
    # begin
    #   say "Creando secuencia para el numero de factura"
    #   execute 'CREATE SEQUENCE ventas_nro_factura_seq START 1;'
    # rescue => e
    #   say "Sin soporte para Secuencias"
    # end

    create_table :ventas do |t|
      t.references :cliente, index: true
      t.float :descuento
      t.float :total
      t.float :iva10
      t.float :iva5
      t.boolean :credito
      t.boolean :pagado
      t.string :nro_factura
      t.integer :cantidad_cuotas, :default => 0

      t.timestamps
    end

    # begin
    #   say "Adding NEXTVAL('ventas_nro_factura_seq') to column nro_factura"
    #   execute "ALTER TABLE ventas ALTER COLUMN nro_factura SET DEFAULT NEXTVAL('ventas_nro_factura_seq');"
    # rescue => e
    #   say "Sin soporte para Secuencias"
    # end
  end

  def down
    drop_table :ventas

    # begin
    #   say "Eliminando secuencia"
    #   execute 'DROP SEQUENCE IF EXISTS ventas_nro_factura_seq;'
    # rescue => e
    #   say "Sin soporte para Secuencias"
    # end
  end
end

