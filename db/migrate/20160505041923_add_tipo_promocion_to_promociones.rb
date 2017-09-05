class AddTipoPromocionToPromociones < ActiveRecord::Migration
  def change
    add_column :promociones, :a_partir_de, :boolean, default: false
    add_column :promociones, :por_unidad, :boolean, default: true
  end
end
