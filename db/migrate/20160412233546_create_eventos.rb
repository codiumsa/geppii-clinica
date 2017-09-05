class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :tipo
      t.string :observacion
      t.date :fecha

      t.timestamps
    end
  end
end
