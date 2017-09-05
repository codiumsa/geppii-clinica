class CreateCotizaciones < ActiveRecord::Migration
  def change
    create_table :cotizaciones do |t|
      t.decimal :monto
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
