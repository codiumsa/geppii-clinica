class AddNumeroClienteAutogenerado < ActiveRecord::Migration
  def change
    execute "CREATE SEQUENCE numero_cliente_seq START 100"
    execute "ALTER TABLE clientes ALTER numero_cliente SET DEFAULT NEXTVAL('numero_cliente_seq')"
  end
end
