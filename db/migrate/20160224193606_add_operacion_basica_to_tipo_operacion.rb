class AddOperacionBasicaToTipoOperacion < ActiveRecord::Migration
  def change
    add_column :tipos_operacion, :operacion_basica, :boolean, default: false
  end
end
