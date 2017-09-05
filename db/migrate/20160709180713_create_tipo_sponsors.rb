class CreateTipoSponsors < ActiveRecord::Migration
  def change
    create_table :tipo_sponsors do |t|
      t.string :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
