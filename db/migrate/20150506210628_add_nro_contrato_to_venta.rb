class AddNroContratoToVenta < ActiveRecord::Migration
  def change
    add_column :ventas, :nro_contrato, :string
  end
end
