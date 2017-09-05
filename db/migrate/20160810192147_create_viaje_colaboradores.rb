class CreateViajeColaboradores < ActiveRecord::Migration
  def change
    create_table :viaje_colaboradores do |t|
      t.references :viaje, index: true
      t.references :colaborador, index: true
      t.float :costo_ticket
      t.float :costo_estadia
      t.string :companhia
      t.string :observacion
      t.timestamps
    end
  end
end
