class AddTipoCajaToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :tipo_caja, :string
  end
end
