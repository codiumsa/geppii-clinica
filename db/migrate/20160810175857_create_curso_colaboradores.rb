class CreateCursoColaboradores < ActiveRecord::Migration
  def change
    create_table :curso_colaboradores do |t|
      t.references :curso, index: true
      t.references :colaborador, index: true
      t.string :observacion
    end
  end
end
