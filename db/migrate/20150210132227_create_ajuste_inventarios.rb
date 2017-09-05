class CreateAjusteInventarios < ActiveRecord::Migration
  def change
    create_table :ajuste_inventarios do |t|
      t.date :fecha
      t.string :observacion

      t.timestamps
    end
  end
end
