class CreateColaboradores < ActiveRecord::Migration
  def change
    create_table :colaboradores do |t|
      t.references :persona, index: true
      t.references :tipo_colaborador, index: true
      t.references :especialidad, index: true
      t.boolean :voluntario

      t.timestamps
    end
  end
end
