class CreateTratamientos < ActiveRecord::Migration
  def change
    create_table :tratamientos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
