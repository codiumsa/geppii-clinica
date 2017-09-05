class CreateConsultorios < ActiveRecord::Migration
  def change
    create_table :consultorios do |t|
      t.string :codigo
      t.string :descripcion
      t.references :especialidad, index: true
      t.timestamps
    end
  end
end
