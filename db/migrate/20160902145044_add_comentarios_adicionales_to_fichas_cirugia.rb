class AddComentariosAdicionalesToFichasCirugia < ActiveRecord::Migration
  def change
    add_column :fichas_cirugia, :comentarios_adicionales, :text
  end
end
