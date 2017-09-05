class AddAcreditadoToColaboradores < ActiveRecord::Migration
  def change
    add_column :colaboradores, :acreditado, :boolean, default: false
    add_column :colaboradores, :comisionamiento, :boolean, default: false
    add_column :colaboradores, :tipo, :string
    add_column :colaboradores, :titulo, :string
    add_column :colaboradores, :institucion, :string
    add_column :colaboradores, :talle_remera, :string
    add_column :colaboradores, :lugar_trabajo_1, :string
    add_column :colaboradores, :lugar_trabajo_3, :string
    add_column :colaboradores, :lugar_trabajo_2, :string
    add_column :colaboradores, :horario_trabajo_1, :string
    add_column :colaboradores, :horario_trabajo_3, :string
    add_column :colaboradores, :horario_trabajo_2, :string
    add_column :colaboradores, :vencimiento_registro_medico, :string
    add_column :colaboradores, :vencimiento_bls, :string
    add_column :colaboradores, :vencimiento_pals, :string
    add_column :colaboradores, :otros, :string

  end
end
