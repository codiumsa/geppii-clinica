class CreateTipoSalidas < ActiveRecord::Migration
  def change
    create_table :tipo_salidas do |t|
      t.string :codigo
      t.string :descripcion
    end
  end
end
