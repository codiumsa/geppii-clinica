class AddNombreClubToColaboradores < ActiveRecord::Migration
  def change
    add_column :colaboradores, :nombre_club, :string
  end
end
