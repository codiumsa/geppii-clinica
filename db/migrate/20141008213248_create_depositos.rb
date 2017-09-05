class CreateDepositos < ActiveRecord::Migration
  def change
    create_table :depositos do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end
end
