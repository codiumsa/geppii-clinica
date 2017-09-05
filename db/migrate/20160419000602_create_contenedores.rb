class CreateContenedores < ActiveRecord::Migration
  def change
      create_table :contenedores do |t|
        t.string :nombre
        t.string :codigo
      t.timestamps
    end
  end
end