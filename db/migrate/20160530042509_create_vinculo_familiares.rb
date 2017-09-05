class CreateVinculoFamiliares < ActiveRecord::Migration
  def change
    create_table :vinculo_familiares do |t|
      t.string :tipo

      t.timestamps
    end
  end
end
