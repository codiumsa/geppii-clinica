class AddComentariosToFichasPsicologia < ActiveRecord::Migration
  def change
    add_column :fichas_psicologia, :comentarios, :text
  end
end
