class AddNombreContactoClubToColaboradores < ActiveRecord::Migration
  def change
    add_column :colaboradores, :nombre_contacto_club, :string
    add_column :colaboradores, :celular_contacto_club, :string
    add_column :colaboradores, :email_contacto_club, :string
  end
end
