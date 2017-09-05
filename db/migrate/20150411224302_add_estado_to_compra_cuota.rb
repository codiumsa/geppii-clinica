class AddEstadoToCompraCuota < ActiveRecord::Migration
  def change
    add_column :compra_cuotas, :estado, :string
  end
end
