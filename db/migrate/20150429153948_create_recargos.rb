class CreateRecargos < ActiveRecord::Migration
  def change
    create_table :recargos do |t|
      t.integer :cantidad_cuotas
      t.float :interes

      t.timestamps
    end
  end
end
