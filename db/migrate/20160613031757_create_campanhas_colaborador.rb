class CreateCampanhasColaborador < ActiveRecord::Migration
  def change
    create_table :campanhas_colaboradores do |t|
      t.references :colaborador, index: true
      t.references :campanha, index: true
      t.string :observaciones
      t.timestamps
    end
  end
end
