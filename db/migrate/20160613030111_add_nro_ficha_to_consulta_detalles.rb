class AddNroFichaToConsultaDetalles < ActiveRecord::Migration
  def change
    add_column :consulta_detalles, :nro_ficha, :integer
    add_column :consulta_detalles, :referencia_id, :string
    add_column :consulta_detalles, :referencia_nombre, :string
    add_column :consulta_detalles, :estado, :string
    add_column :consulta_detalles, :fecha_inicio, :datetime
    add_column :consulta_detalles, :fecha_fin, :datetime
  end
end
