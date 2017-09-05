class AddComisionToVendedor < ActiveRecord::Migration
  def change
    add_column :vendedores, :comision, :float, :default => 0.0
  end
end
