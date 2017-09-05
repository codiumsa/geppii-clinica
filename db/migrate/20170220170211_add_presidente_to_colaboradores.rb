class AddPresidenteToColaboradores < ActiveRecord::Migration
  def change
    add_column :colaboradores, :nombre_presidente_club, :string
    add_column :colaboradores, :celular_presidente_club, :string
    add_column :colaboradores, :correo_presidente_club, :string
  end
end
