class AddEsClubToTipoColaboradores < ActiveRecord::Migration
  def change
    add_column :tipo_colaboradores, :es_club, :boolean, default: false
  end
end
