class AddCajaToUsuario < ActiveRecord::Migration
  def change
    add_reference :usuarios, :caja, index: true
  end
end
