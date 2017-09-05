class AddUsuarioToAjusteInventario < ActiveRecord::Migration
  def change
    add_reference :ajuste_inventarios, :usuario, index: true
  end
end
