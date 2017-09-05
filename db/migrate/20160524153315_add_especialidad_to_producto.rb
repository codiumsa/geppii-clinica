class AddEspecialidadToProducto < ActiveRecord::Migration
  def change
    add_reference :productos, :especialidad, index: true
    add_column :productos, :es_procedimiento, :boolean, default: false
  end
end
