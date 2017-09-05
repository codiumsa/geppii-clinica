class AddPermitePromocionesToParametrosEmpresa < ActiveRecord::Migration
  def change
    add_column :parametros_empresas, :permite_promociones, :boolean, default: true
  end
end
